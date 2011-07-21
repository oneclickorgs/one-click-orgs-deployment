require 'digest/sha1'
require 'digest/md5'
require 'lib/vote_error'

class Member < ActiveRecord::Base
  state_machine :initial => :pending do
    event :induct do
      transition :pending => :active
    end
    
    event :eject do
      transition [:pending, :active] => :inactive
    end
    
    event :reactivate do
      transition :inactive => :active, :if => :inducted?
      transition :inactive => :pending
    end
    
    after_transition :on => :induct, :do => :timestamp_induction!
    
    after_transition :on => :reactivate, :do => [
      :new_invitation_code!,
      :send_welcome
    ]
  end
  
  attr_accessor :send_welcome
  
  before_create :new_invitation_code
  after_create :send_welcome_if_requested
  
  belongs_to :organisation
  
  has_many :votes
  has_many :proposals, :foreign_key => 'proposer_member_id'
  belongs_to :member_class
  
  scope :active, with_state(:active)
  scope :inactive, with_state(:inactive)
  scope :pending, with_state(:pending)
  
  scope :founders, lambda {|org| { :conditions => { :member_class_id => org.member_classes.where(:name => 'Founder').first } } }
  scope :founding_members, lambda {|org| { :conditions => { :member_class_id => org.member_classes.where(:name => 'Founding Member').first } } }
  
  validates_uniqueness_of :invitation_code, :scope => :organisation_id, :allow_nil => true
  
  validates_confirmation_of :password
  
  attr_accessor :terms_and_conditions
  validates_acceptance_of :terms_and_conditions
  
  before_save :timestamp_terms_acceptance
  def timestamp_terms_acceptance
    if terms_and_conditions && terms_and_conditions != 0 && terms_and_conditions != '0'
      self.terms_accepted_at ||= Time.now.utc
    end
  end
  
  def timestamp_induction!
    update_attribute(:inducted_at, Time.now.utc)
  end

  def proposals_count
    proposals.count
  end
  
  def succeeded_proposals_count
    proposals.where(:state => 'accepted').count
  end
  
  def failed_proposals_count
    proposals.where(:state => 'rejected').count
  end
  
  def votes_count
    votes.count
  end

  validates_presence_of :first_name, :last_name, :email
  validates_format_of :email, :with => /\A.*@.*\..*\Z/
  # TODO: how can we validate :password? (not actually saved, but accepted during input)

  # AUTHENTICATION

  attr_accessor :password, :password_confirmation

  # Encrypts some data with the salt
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  def self.authenticate(login, password)
    member = where(:email => login).first
    member && member.authenticated?(password) ? member : nil
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--:email--") if new_record?
    self.crypted_password = encrypt(password)
  end

  before_save :encrypt_password

  # END AUTHENTICATION
  
  def eligible_to_vote?(proposal)
    return true if organisation.try(:proposed?)
    inducted? && proposal.creation_date >= inducted_at
  end
  
  def cast_vote(action, proposal)
    raise ArgumentError, "need action and proposal" unless action and proposal

    existing_vote = Vote.where(:member_id => self.id, :proposal_id => proposal.id).first
    raise VoteError, "Vote already exists for this proposal" if existing_vote

    unless eligible_to_vote?(proposal)
      raise VoteError, "Cannot vote on proposals created before member is inducted and the organisation has been proposed."
    end

    case action
    when :for
      Vote.create(:member => self, :proposal => proposal, :for => true)
    when :against
      Vote.create(:member => self, :proposal => proposal, :for => false)
    end
  end
  
  def send_welcome_if_requested
    return unless @send_welcome
    
    if self.organisation.pending? then
      MembersMailer.welcome_new_founding_member(self).deliver
    else
      MembersMailer.welcome_new_member(self).deliver
    end
  end
  
  def inducted?
    !inducted_at.nil?
  end
  
  def to_event
    if self.inducted?
      {:timestamp => self.inducted_at, :object => self, :kind => :new_member}
    end
  end
  
  def has_permission(type)
    return false if member_class.nil? # XXX should always have a member class?
    member_class.has_permission(type)
  end
  
  def name
    full_name = [first_name, last_name].compact.join(' ')
    full_name.blank? ? nil : full_name
  end
  
  # A member is a founding member if they were created before the organisation's
  # founding proposal, or if they are in an organisation that has not had a
  # founding proposal yet.
  def founding_member?
    fop = organisation.found_organisation_proposals.last
    if fop
      self.created_at < fop.creation_date
    else
      true
    end
  end

  # INVITATION CODE
  
  def self.generate_invitation_code
    Digest::SHA1.hexdigest("#{Time.now}#{rand}")[0..9]
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
  
  # PASSWORD RESET CODE
  
  def self.generate_password_reset_code
    Digest::SHA1.hexdigest("#{Time.now}#{rand}")[0..9]
  end
  
  def new_password_reset_code!
    self.password_reset_code = self.class.generate_password_reset_code
  end
  
  def clear_password_reset_code!
    self.update_attribute(:password_reset_code, nil)
  end
  
  # GRAVATAR
  
  def gravatar_url(size)
    hash = Digest::MD5.hexdigest(email.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=#{size}&d=mm"
  end
  
  # FOUNDING VOTE
  
  def founding_vote
    # The first vote of a founder will always be the founding vote
    self.votes.first
  end
  
  # NOTIFICATIONS
  
  has_many :seen_notifications
  
  # Check if this notification has been shown to user already.
  #
  # There is an assumption that a user will never require more than one of the
  # same kind of notification, at the same time as another
  #
  # @param [Symbol] notification the kind of notification
  # @param [optional, Timestamp] created_at when the notification was created
  #
  # @example Check that a user saw that her latest proposal in an organisation failed at a particular time in June
  #   current_user.has_seen_notification?(:founding_proposal_failed, "2011-06-04 13:14:37")
  #
  def has_seen_notification?(notification, created_at = '')
    seen_notifications.exists?(:notification => notification, :created_at => created_at)
  end
  
  def has_seen_notification!(notification)
    unless has_seen_notification?(notification)
      seen_notifications.create(:notification => notification)
    end
  end
end
