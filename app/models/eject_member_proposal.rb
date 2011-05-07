class EjectMemberProposal < MembershipProposal

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
end
