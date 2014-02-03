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

      # TODO Move this to somewhere more sensible
      if member.organisation.is_a?(Coop)
        member.induct!

        st = ShareTransaction.create(
          :to_account => @member.find_or_create_share_account,
          :from_account => @member.organisation.share_account,
          :amount => 1
        )
        st.save!
      end

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
    :address, :address=,
    :to => :member

  def id
    member.try(:invitation_code)
  end

  def persisted?
    member && member.persisted?
  end

  def self.find_by_id(id)
    member = Member.find_by_invitation_code(id)
    if member && member.pending?
      new(:member => member)
    else
      nil
    end
  end
end
