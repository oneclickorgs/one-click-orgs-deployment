class ChangeVotingSystemProposal < ConstitutionProposal
  def allows_direct_edit?
    true
  end

  def enact!(params)
    organisation.constitution.change_voting_system(params['type'], params['proposed_system'])
  end
end
