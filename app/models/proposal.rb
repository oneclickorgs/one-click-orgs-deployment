require 'one_click_orgs/parameters_serialisation'

class Proposal < ActiveRecord::Base
  include OneClickOrgs::ParametersSerialisation

  attr_accessible :title, :proposer_member_id, :description, :parameters

  state_machine :initial => :open do
    event :close do
      transition any => :accepted, :if => :passed?
      transition any => :rejected
    end

    event :start do
      transition :draft => :open
    end

    after_transition any => :accepted, :do => [:enact!, :create_a_decision]
    after_transition any => :rejected, :do => [:after_reject]
  end

  belongs_to :organisation
  belongs_to :proposer, :class_name => 'Member', :foreign_key => 'proposer_member_id'

  has_many :votes, :dependent => :destroy
  has_many :voters_for, through: :votes, source: :member, conditions: ['votes.for = ?', true]

  has_one :decision
  has_many :comments, :as => :commentable

  validates_presence_of :proposer

  scope :currently_open, lambda {where(["state = 'open' AND close_date > ?", Time.now.utc])}
  scope :failed, lambda {where(["close_date < ? AND state = 'rejected'", Time.now.utc]).order('close_date DESC')}

  scope :draft, with_state(:draft)
  scope :accepted, with_state(:accepted)
  scope :rejected, with_state(:rejected)

  attr_accessor :force_passed

  # FINDERS

  def self.find_closeable_early_proposals
    currently_open.all.select { |p| p.voting_system.can_be_closed_early?(p) }
  end

  def self.close_early_proposals
    find_closeable_early_proposals.each { |p| p.close! }
  end

  # CLASS METHODS

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

  # VOTING PERIOD

  def voting_period_in_days
    voting_period / 1.day
  end

  def voting_period_in_days=(new_voting_period_in_days)
    self.voting_period = new_voting_period_in_days.to_i.days
  end

  def voting_period
    @voting_period || organisation.constitution.voting_period
  end

  def voting_period=(new_voting_period)
    @voting_period = new_voting_period.to_i
  end

  # GETTERS

  def end_date
    self.close_date
  end

  def accepted_or_rejected
    accepted? ? "accepted" : "rejected"
  end

  def closed?
    accepted? || rejected?
  end

  def voting_system
    organisation.constitution.voting_system(:general)
  end

  def passed?
    @force_passed || voting_system.passed?(self)
  end

  # ASSOCIATION HELPERS

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

  # CALCULATIONS

  def abstained
    member_count - total_votes
  end

  def total_votes
    votes_for + votes_against
  end

  def duration
    creation_date && end_date && (end_date - creation_date)
  end

  # BEHAVIOUR REDEFINED BY SUBCLASSES

  def enact!
  end

  def after_reject
  end

  # Should the proposal automatically create a support vote by the
  # proposer when the proposal is started?
  def automatic_proposer_support_vote?
    true
  end

  def decision_notification_message
  end

  # CALLBACKS

  after_create :cast_support_vote_by_proposer
  def cast_support_vote_by_proposer
    proposer.cast_vote(:for, self) if automatic_proposer_support_vote?
  end

  # TIMELINE

  def to_event
    {:timestamp => self.creation_date, :object => self, :kind => (closed? && !accepted?) ? :failed_proposal : :proposal }
  end

  # MISCELLANEOUS

  # This works around a bug in state_machine which means we cannot specify #create_decision
  # directly in the after_transition callback. If we do, ActiveRecord attempts to use the
  # Transition object as attributes to the new Decision object, resulting ultimately in an
  # "undefined method `stringify_keys'" error on the Transition object.
  def create_a_decision
    create_decision
  end
end
