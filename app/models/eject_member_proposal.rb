class EjectMemberProposal < MembershipProposal
  before_create :set_default_title
  def set_default_title
    self.title ||= "Eject #{organisation.members.find(member_id).name} from #{organisation.name}"
  end

  def enact!
    # TODO why is this check here and not in the base class? and do we need a check here at all?
    raise "Can not enact a proposal which has not passed" unless passed?
    
    # TODO: Needs backwards compatibility; previously stored the member's ID in
    # the 'id' key, not 'member_id'
    member = organisation.members.find(parameters['member_id'])
    if organisation.pending?
      # Special case: org in pending state
      member.destroy
    else
      member.eject!
    end
  end
  
  def member_id
    parameters['member_id']
  end
  
  def member_id=(member_id)
    parameters['member_id'] = member_id.to_i
  end
end
