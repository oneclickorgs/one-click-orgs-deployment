require 'one_click_orgs/parameters_serialisation'

class Proposal < ActiveRecord::Base
  include OneClickOrgs::ParametersSerialisation
  
  state_machine :initial => :open do
    event :close do
      transition :open => :accepted, :if => :passed?
      transition :open => :rejected
    end
    
    after_transition any => :accepted, :do => [:enact!, :create_a_decision]
    after_transition any => :rejected, :do => [:after_reject]
  end
  
  belongs_to :organisation
  
  after_create :send_email
  
  has_many :votes
  has_one :decision
  
  belongs_to :proposer, :class_name => 'Member', :foreign_key => 'proposer_member_id'
  
  has_many :comments, :as => :commentable
  
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
    organisation.member_count_for_proposal(self)
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
  
  # This works around a bug in state_machine which means we cannot specify #create_decision
  # directly in the after_transition callback. If we do, ActiveRecord attempts to use the
  # Transition object as attributes to the new Decision object, resulting ultimately in an
  # "undefined method `stringify_keys'" error on the Transition object.
  def create_a_decision
    create_decision
  end
end
