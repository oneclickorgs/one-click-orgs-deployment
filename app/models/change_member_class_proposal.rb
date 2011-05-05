class ChangeMemberClassProposal < MembershipProposal

  def allows_direct_edit?
    true
  end

  def enact!(params)
    member = organisation.members.find(params['id']) # TODO verify that this member still exists
    mc = organisation.member_classes.find(params['member_class_id']) # TODO verify that this member class still exists
    member.member_class = mc
    member.save
  end
  
  before_create :set_default_title
  def set_default_title
    member = organisation.members.find(parameters['member_id'])
    member_class = organisation.member_classes.find(parameters['member_class_id'])
    self.title ||= "Change member class of #{member.name} from #{member.member_class.name} to #{member_class.name}"
  end
end
