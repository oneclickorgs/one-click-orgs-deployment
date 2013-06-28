require 'one_click_orgs/cast_to_boolean'

class Resolution < Proposal
  include OneClickOrgs::CastToBoolean

  attr_accessible :draft, :voting_period_in_days, :extraordinary, :certification

  state_machine do
    event :attach do
      transition :draft => :attached
    end

    event :pause do
      transition :open => :paused
    end
  end

  belongs_to :meeting

  scope :attached, with_state(:attached)
  scope :paused,   with_state(:paused)

  attr_accessor :certification, :attached, :passed, :open

  # DRAFT STATE

  def draft=(new_draft)
    # TODO Refactor this and #draft and #draft? to use #cast_to_boolean
    if new_draft == 'true'
      new_draft = true
    elsif new_draft == 'false'
      new_draft = false
    elsif new_draft.respond_to?(:to_i)
      if new_draft.to_i == 1
        new_draft = true
      elsif new_draft.to_i == 0
        new_draft = false
      end
    end

    @draft = new_draft
  end

  def draft
    !!@draft
  end

  before_create :set_draft_state
  def set_draft_state
    if draft
      self.state = 'draft'
    end
  end

  # IMMEDIATE PASSING

  attr_accessor :pass_immediately

  def pass_immediately?
    cast_to_boolean(@pass_immediately)
  end

  after_create :pass_immediately_if_requested
  def pass_immediately_if_requested
    return unless pass_immediately?

    self.force_passed = true
    close!
  end

  # ATTRIBUTES

  def extraordinary=(new_extraordinary)
    @extraordinary = new_extraordinary
  end

  def extraordinary
    !!@extraordinary
  end

  before_create :set_default_title
  def set_default_title
    if title.blank?
      self.title = description.truncate(200)
    end
  end

  # Resolutions are often created by request on behalf of the membership
  # (e.g. by the secretary), so the 'proposer' isn't necessarily in
  # favour of the proposal. So for Resolutions, we don't automatically
  # make the proposer support the proposal.
  def automatic_proposer_support_vote?
    false
  end

  def voting_system
    VotingSystems.get(:AbsoluteMajority)
  end

  def votes_for
    if additional_votes_for.present?
      (super - double_voters(:for)) + additional_votes_for
    else
      super
    end
  end

  def votes_against
    if additional_votes_against.present?
      (super - double_voters(:against)) + additional_votes_against
    else
      super
    end
  end

  def double_voters(for_or_against)
    return 0 unless meeting

    if for_or_against == :for
      voters = votes.where(:for => 1).map(&:member)
    else
      voters = votes.where(:for => 0).map(&:member)
    end

    meeting.participants.select{|p| voters.include?(p)}.count
  end

  def to_event
    {:timestamp => self.creation_date, :object => self, :kind => draft? ? :draft_resolution : :resolution }
  end

  def creation_success_message
    if draft?
      "The draft proposal has been saved."
    elsif open?
      "The proposal has been opened for electronic voting."
    end
  end

  def self.run_daily_job
    # Consider Resolutions that are attached to a meeting and also open for electronic voting.
    # If the meeting is happening today, we pause electronic voting.
    currently_open.where('meeting_id IS NOT NULL').all.each do |resolution|
      if resolution.meeting && resolution.meeting.happened_on == Time.now.utc.to_date
        resolution.pause!
      end
    end
  end

end
