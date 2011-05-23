class ChangeMemberClassProposal < MembershipProposal
  validate :member_must_exist
  def member_must_exist
    errors.add(:member, "does not exist") unless organisation.members.exists?(parameters['member_id'])
  end
  
  validate :member_class_must_exist
  def member_class_must_exist
    errors.add(:member_class, "does not exist") unless organisation.member_classes.exists?(parameters['member_class_id'])
  end
  
  def allows_direct_edit?
    true
  end

  def enact!(params)
    # TODO: Needs backwards compatibility; previously stored the member's ID in
    # the 'id' key, not 'member_id'
    
    member = organisation.members.find(params['member_id']) # TODO verify that this member still exists
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
  
  def member_id
    parameters['member_id']
  end
  
  def member_id=(member_id)
    parameters['member_id'] = member_id.to_i
  end
  
  def member_class_id
    parameters['member_class_id']
  end
  
  def member_class_id=(member_class_id)
    parameters['member_class_id'] = member_class_id.to_i
  end
  
  def member
    organisation.members.find(member_id)
  end
end
