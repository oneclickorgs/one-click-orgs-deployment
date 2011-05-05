class EjectMemberProposal < MembershipProposal
  before_create :set_default_title
  def set_default_title
    self.title ||= "Eject #{organisation.members.find(member_id).name} from #{organisation.name}"
  end
  
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
