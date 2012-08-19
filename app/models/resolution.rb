require 'one_click_orgs/cast_to_boolean'

class Resolution < Proposal
  include OneClickOrgs::CastToBoolean

  attr_accessible :draft, :voting_period_in_days, :extraordinary, :certification
  
  attr_accessor :certification, :attached, :passed
  
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

  def to_event
    {:timestamp => self.creation_date, :object => self, :kind => draft? ? :draft_resolution : :resolution }
  end

end
