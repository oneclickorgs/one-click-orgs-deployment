class AddMemberProposal < MembershipProposal
  attr_accessible :draft_member, :first_name, :last_name, :email, :member_class_id
  
  attr_accessor :draft_member
  
  validate :member_must_not_already_be_active
  def member_must_not_already_be_active
    errors.add(:base, "A member with this email address already exists") if organisation.members.active.find_by_email(parameters['email'])
  end
  
  validate :member_attributes_must_be_valid
  def member_attributes_must_be_valid
    @draft_member = organisation.members.build(parameters, :as => :proposal)
    @draft_member.allow_duplicate_email = true
    unless @draft_member.valid?
      @draft_member.errors.each do |attribute, message|
        errors.add(attribute, message)
      end
    end
  end
  
  before_create :set_default_title
  def set_default_title
    self.title ||= "Add #{parameters['first_name']} #{parameters['last_name']} as a member of #{organisation.try(:name)}"
  end

  def enact!
    @existing_member = organisation.members.inactive.find_by_email(parameters['email'])
    if @existing_member
      @existing_member.reactivate!
    else
      member = organisation.members.build(parameters, :as => :proposal)
      member.send_welcome = true
      member.save!
    end
  end
  
  def email
    parameters['email']
  end
  
  def email=(email)
    self.parameters['email'] = email
  end
  
  def first_name
    parameters['first_name']
  end
  
  def first_name=(first_name)
    self.parameters['first_name'] = first_name
  end
  
  def last_name
    parameters['last_name']
  end
  
  def last_name=(last_name)
    self.parameters['last_name'] = last_name
  end
  
  def member_class_id
    parameters['member_class_id']
  end
  
  def member_class_id=(member_class_id)
    self.parameters['member_class_id'] = member_class_id
  end
end
