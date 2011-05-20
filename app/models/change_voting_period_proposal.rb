# Represents a proposal to change the voting period for propsosals.
class ChangeVotingPeriodProposal < ConstitutionProposal
  before_create :set_default_title
  def set_default_title
    self.title ||= "Change voting period to #{VotingPeriods.name_for_value(new_voting_period)}"
  end
  
  def allows_direct_edit?
    true
  end

  def enact!(params)
    organisation.constitution.change_voting_period(params['new_voting_period'].to_i)
  end
  
  def new_voting_period
    parameters['new_voting_period']
  end
  
  def new_voting_period=(new_voting_period)
    parameters['new_voting_period'] = new_voting_period
  end
end
