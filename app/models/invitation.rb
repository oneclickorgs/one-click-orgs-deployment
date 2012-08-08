require 'one_click_orgs/model_wrapper'

# Wraps a Member instance, allowing finding via invitation_code, and
# access to the member's password attributes.
#
# Includes some logic about what should happen during the process of
# processing a member's invitation.
class Invitation < OneClickOrgs::ModelWrapper
  def after_initialize
    raise ArgumentError, "Member must be supplied" unless member

    if member.organisation.terms_and_conditions_required?
      self.terms_and_conditions = '0'
    end
  end

  def show_founding_warnings?
    member && member.founding_member?
  end

  def clear_invitation_code!
    member.clear_invitation_code!
  end

  def save
    if member.save
      clear_invitation_code!
      true
    else
      false
    end
  end

  attr_reader :member

  def member=(member)
    @member = member
    id = member.invitation_code
  end

  delegate :name,
    :first_name, :first_name=,
    :last_name, :last_name=,
    :email, :email=,
    :password, :password=,
    :password_confirmation, :password_confirmation=,
    :terms_and_conditions, :terms_and_conditions=,
    :to => :member

  def id
    member.try(:invitation_code)
  end

  def persisted?
    member && member.persisted?
  end

  def self.find_by_id(id)
    member = Member.find_by_invitation_code(id)
    if member
      new(:member => member)
    else
      nil
    end
  end
end
