# Represents a proposal to change the voting period for propsosals.
class ChangeVotingPeriodProposal < ConstitutionProposal
  attr_accessible :new_voting_period
  
  before_create :set_default_title
  def set_default_title
    self.title ||= "Change voting period to #{VotingPeriods.name_for_value(new_voting_period)}"
  end

  def enact!
    organisation.constitution.change_voting_period(parameters['new_voting_period'].to_i)
  end
  
  def new_voting_period
    parameters['new_voting_period']
  end
  
  def new_voting_period=(new_voting_period)
    parameters['new_voting_period'] = new_voting_period
  end
end
