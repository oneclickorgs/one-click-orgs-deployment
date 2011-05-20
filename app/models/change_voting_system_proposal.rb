class ChangeVotingSystemProposal < ConstitutionProposal
  def allows_direct_edit?
    true
  end

  def enact!(params)
    # TODO needs backwards compatiblity; previous proposals used 'type' instead of 'proposal_type'
    organisation.constitution.change_voting_system(params['proposal_type'], params['proposed_system'])
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
