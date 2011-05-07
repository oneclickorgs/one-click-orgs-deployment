class EjectMemberProposal < Proposal

  def allows_direct_edit?
    true
  end

  def enact!(params)
    raise "Can not enact a proposal which has not passed" unless passed?
    member = organisation.members.find(params['id'])
    if organisation.pending?
      # Special case: org in pending state
      member.destroy
    else
      member.eject!
    end
  end
  
  def voting_system
    organisation.constitution.voting_system(:membership)
  end
  
  def decision_notification_message
    "If you have previously printed/saved a PDF copy of the member list, this prior copy is now out of date. Please consider reprinting/saving a copy of the latest member list for your records."
  end

end
