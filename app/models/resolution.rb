class Resolution < Proposal
  attr_accessible :draft, :voting_period_in_days, :extraordinary, :certification
  
  attr_accessor :certification
  
  # DRAFT STATE
  
  def draft=(new_draft)
    @draft = new_draft
  end
  
  def draft
    !!@draft
  end
  
  def extraordinary=(new_extraordinary)
    @extraordinary = new_extraordinary
  end
  
  def extraordinary
    !!@extraordinary
  end
  
  before_create :set_draft_state
  def set_draft_state
    if draft
      self.state = 'draft'
    end
  end
  
  # Resolutions are often created by request on behalf of the membership
  # (e.g. by the secretary), so the 'proposer' isn't necessarily in
  # favour of the proposal. So for Resolutions, we don't automatically
  # make the proposer support the proposal.
  def automatic_proposer_support_vote?
    false
  end
end
