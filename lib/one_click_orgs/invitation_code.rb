require 'digest/sha1'
require 'active_support/concern'

module OneClickOrgs

  # Handles the invitation code for a new user
  module InvitationCode
    extend ActiveSupport::Concern

    included do
      before_create :new_invitation_code

      validates_uniqueness_of :invitation_code, :scope => :organisation_id, :allow_nil => true

      if respond_to?(:state_machines)
        state_machines[:state].after_transition :on => :reactivate, :do => :new_invitation_code!
      end
    end

    def new_invitation_code
      self.invitation_code = self.class.generate_invitation_code
    end

    def new_invitation_code!
      new_invitation_code
      save!
    end

    def clear_invitation_code!
      self.update_attribute(:invitation_code, nil)
    end

    module ClassMethods
      def generate_invitation_code
        Digest::SHA1.hexdigest("#{Time.now}#{rand}")[0..9]
      end
    end
  end
end
