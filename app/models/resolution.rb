class Resolution < Proposal
  attr_accessible :draft, :voting_period_in_days, :extraordinary, :certification
  
  attr_accessor :certification
  
  # DRAFT STATE
  
  def draft=(new_draft)
    # TODO There must be something built-in to Rails to handle this.
    if new_draft.respond_to?(:to_i)
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
  
  before_create :set_title
  def set_title
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
end
