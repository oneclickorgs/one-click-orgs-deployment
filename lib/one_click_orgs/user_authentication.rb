require 'digest/sha1'
require 'active_support/concern'

module OneClickOrgs
  
  # Handles authentication for a user object, including password resets and
  # invitation code for a new user.
  module UserAuthentication
    extend ActiveSupport::Concern
    
    included do
      before_create :new_invitation_code
      
      before_save :encrypt_password
      
      validates_uniqueness_of :invitation_code, :scope => :organisation_id, :allow_nil => true
      validates_confirmation_of :password
      
      # TODO: how can we validate :password? (not actually saved, but accepted during input)
      
      # after_transition :reactivate, :new_invitation_code!
      state_machines[:state].after_transition :on => :reactivate, :do => :new_invitation_code!
    end
    
    attr_accessor :password, :password_confirmation
    
    def authenticated?(password)
      crypted_password == encrypt(password)
    end

    def encrypt(password)
      self.class.encrypt(password, salt)
    end
    
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--:email--")
      self.crypted_password = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    # INVITATION CODE

    def new_invitation_code
      self.invitation_code = self.class.generate_invitation_code
    end

    def new_invitation_code!
      new_invitation_code
      save!
    end

    def clear_invitation_code!
      self.update_column(:invitation_code, nil)
    end

    # PASSWORD RESET CODE

    def new_password_reset_code!
      self.password_reset_code = self.class.generate_password_reset_code
    end

    def clear_password_reset_code!
      self.update_attribute(:password_reset_code, nil)
    end

    module ClassMethods
      # Encrypts some data with the salt
      def encrypt(password, salt)
        Digest::SHA1.hexdigest("--#{salt}--#{password}--")
      end

      def authenticate(login, password)
        member = where(:email => login).first
        member && member.authenticated?(password) ? member : nil
      end
      
      # INVITATION CODE
      
      def generate_invitation_code
        Digest::SHA1.hexdigest("#{Time.now}#{rand}")[0..9]
      end
      
      # PASSWORD RESET CODE
      
      def generate_password_reset_code
        Digest::SHA1.hexdigest("#{Time.now}#{rand}")[0..9]
      end
    end
  end
end
