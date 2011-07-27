class Proposal < ActiveRecord::Base
  state_machine :initial => :open do
    event :close do
      transition :open => :accepted, :if => :passed?
      transition :open => :rejected
    end
    
    before_transition :on => :close, :do => :set_close_date_to_now
    
    after_transition any => :accepted, :do => [:enact!, :create_decision]
    after_transition any => :rejected, :do => [:after_reject]
  end
  
  def set_close_date_to_now
    self.close_date = Time.now.utc
  end
  
  belongs_to :organisation
  
  after_create :send_email
  
  has_many :votes
  has_one :decision
  
  belongs_to :proposer, :class_name => 'Member', :foreign_key => 'proposer_member_id'
  
  has_many :comments, :as => :commentable
  
  before_create :set_creation_date
  private
  def set_creation_date
    self.creation_date ||= Time.now.utc
  end
  public
  
  before_create :set_close_date
  private
  def set_close_date
    self.close_date ||= Time.now.utc + voting_period
  end
  public
  
  validates_presence_of :proposer_member_id

  def voting_period
    organisation.constitution.voting_period
  end
  
  # Should the proposal automatically create a support vote by the
  # proposer when the proposal is started?
  def automatic_proposer_support_vote?
    true
  end
  
  after_create :cast_support_vote_by_proposer
  def cast_support_vote_by_proposer
    proposer.cast_vote(:for, self) if automatic_proposer_support_vote?
  end
 
  def end_date
    self.close_date
  end
  
  # Returns a Vote by the member specified, or Nil
  def vote_by(member)
    member.votes.where(:proposal_id => self.id).first
  end
  
  def votes_for
    Vote.where(:proposal_id => self.id, :for => true).count
  end
  
  def votes_against
    Vote.where(:proposal_id => self.id, :for => false).count
  end
  
  # returns the number of members who are eligible to vote on this proposal
  def member_count
    # TODO: find out how to do the following in one query
    count = 0
    
    # To vote, a member must be inducted, and must have been added (created)
    # before this proposal was made.
    
    # Members who were founding members are an exception. They are allowed
    # to vote in proposals before they have been inducted.
    # (This is because, by participating in the founding vote, they have
    # already agreed to the constitution.)
    # We determine who was a founding member by seeing whether they were
    # created before the FoundAssociationProposal for this org.
    
    fap = organisation.found_association_proposals.last
    if fap
      organisation.members.where(
        "(state = 'active' AND created_at < :proposal_creation_date) " +
        "OR (state <> 'inactive' and created_at < :founding_date)",
        :proposal_creation_date => creation_date,
        :founding_date => fap.creation_date
      ).each do |m|
        count += 1 if m.has_permission(:vote)
      end
    else
      # FIXME This 'if' branch is checking for the case where there is no
      # FoundAssociationProposal yet, so shouldn't it be including members
      # who haven't been inducted yet (since no member gets inducted during
      # the pending state of the organisation)?
      # 
      # Suspect that this is only working because FoundAssociationProposal
      # overrides #member_count, so this branch never really gets executed.
      organisation.members.active.where(
        "created_at < :proposal_creation_date",
        :proposal_creation_date => creation_date
      ).each do |m|
        count += 1 if m.has_permission(:vote)
      end
    end
    count
  end
  
  def abstained
    member_count - total_votes
  end
  
  def total_votes
    votes_for + votes_against
  end
  
  def after_reject(params={})
    # TODO do some kind of email notification
  end
  
  def accepted_or_rejected
    accepted? ? "accepted" : "rejected"
  end
  
  def enact!
  end
  
  def closed?
    !self.open?
  end
  
  def voting_system
    organisation.constitution.voting_system(:general)
  end

  def passed?
    @force_passed || voting_system.passed?(self)
  end
  
  # Returns the (deserialized) hash of parameters for this proposal.
  # You can call #[]= on the returned hash and it will magically update the
  # actual parameters attribute of the proposal. In other words, this will
  # just work:
  # 
  # proposal.parameters[:first_name] = "Bob"
  # proposal.parameters[:first_name] # => "Bob"
  def parameters
    ParametersHash.from_hash(
      self[:parameters].blank? ? {} : ActiveSupport::JSON.decode(self[:parameters])
    ).tap do |hash|
      hash.proposal = self
    end
  end
  
  def parameters=(new_parameters)
    self[:parameters] = new_parameters.to_json
  end
  
  def self.find_closeable_early_proposals
    currently_open.all.select { |p| p.voting_system.can_be_closed_early?(p) }
  end

  def self.close_due_proposals
    where(["close_date < ? AND state = 'open'", Time.now.utc]).all.each { |p| p.close! }
  end
  
  def self.close_early_proposals
    find_closeable_early_proposals.each { |p| p.close! }
  end
  
  # Called every 60 seconds in the worker process (set up at end of file)
  def self.close_proposals
    close_due_proposals
    close_early_proposals
  end
  
  scope :currently_open, lambda {where(["state = 'open' AND close_date > ?", Time.now.utc])}
  
  scope :failed, lambda {where(["close_date < ? AND state = 'rejected'", Time.now.utc]).order('close_date DESC')}
  
  def send_email
    self.organisation.members.active.each do |m|
      # only notify members who can vote
      ProposalMailer.notify_creation(m, self).deliver if m.has_permission(:vote)
    end
  end
  
  # only to be backwards compatible with systems running older versions of delayed job
  def self.send_email_for(proposal_id)
    Proposal.find(proposal_id).send_email_without_send_later
  end
  
  def to_event
    {:timestamp => self.creation_date, :object => self, :kind => (closed? && !accepted?) ? :failed_proposal : :proposal }
  end

  def duration
    creation_date && end_date && (end_date - creation_date)
  end
  
  def decision_notification_message
    nil
  end  
  
  # A light wrapper around Hash that can retain a reference to a proposal.
  # The reference is used to update the actual parameters attribute of the
  # proposal when the parameters hash is naively updated by calling #[]= on
  # it.
  class ParametersHash < Hash
    attr_accessor :proposal
    
    # Returns a new ParametersHash with the contents of the given hash.
    def self.from_hash(hash)
      hash ? new.replace(hash) : new
    end
    
    def []=(key, value)
      proposal.parameters = proposal.parameters.merge({key => value})
      super
    end
  end
end
