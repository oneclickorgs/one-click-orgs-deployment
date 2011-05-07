class AddMemberProposal < Proposal
  attr_accessor :draft_member
  
  validate :member_must_not_already_be_active
  def member_must_not_already_be_active
    errors.add(:base, "A member with this email address already exists") if organisation.members.active.find_by_email(parameters['email'])
  end
  
  validate :member_attributes_must_be_valid
  def member_attributes_must_be_valid
    @draft_member = organisation.members.build(parameters)
    unless @draft_member.valid?
      errors.add(:base, @draft_member.errors.full_messages.to_sentence)
    end
  end
  
  def allows_direct_edit?
    true
  end

  def enact!(params)
    @existing_member = organisation.members.inactive.find_by_email(params['email'])
    if @existing_member
      @existing_member.reactivate!
    else
      member = organisation.members.build(params)
      member.send_welcome = true
      member.save!
    end
  end
  
  def voting_system
    organisation.constitution.voting_system(:membership)
  end
  
  def decision_notification_message
    "If you have previously printed/saved a PDF copy of the member list, this prior copy is now out of date. Please consider reprinting/saving a copy of the latest member list for your records."
  end
end
