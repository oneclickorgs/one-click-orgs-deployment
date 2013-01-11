class ChangeVotingSystemProposal < ConstitutionProposal
  attr_accessible :proposal_type, :proposed_system
  
  before_create :set_default_title
  def set_default_title
    self.title ||= "Change #{proposal_type.humanize.downcase} voting system to #{VotingSystems.get(proposed_system).description}"
  end

  def enact!
    # TODO needs backwards compatiblity; previous proposals used 'type' instead of 'proposal_type'
    organisation.constitution.change_voting_system(parameters['proposal_type'], parameters['proposed_system'])
  end
  
  def proposal_type
    parameters['proposal_type']
  end
  
  def proposal_type=(proposal_type)
    parameters['proposal_type'] = proposal_type
  end
  
  def proposed_system
    parameters['proposed_system']
  end
  
  def proposed_system=(proposed_system)
    parameters['proposed_system'] = proposed_system
  end
end
