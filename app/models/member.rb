require 'one_click_orgs/user_authentication'
require 'one_click_orgs/invitation_code'
require 'one_click_orgs/notification_consumer'
require 'mail/elements/address'
require 'lib/vote_error'

class Member < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :role, :terms_and_conditions,
    :password, :password_confirmation, :send_welcome,
    :address, :certify_share_application, :certify_age,
    :phone, :member_class_id
  attr_accessible :email, :first_name, :last_name, :role, :terms_and_conditions,
    :password, :password_confirmation, :send_welcome, :member_class_id, :as => :proposal


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

    event :resign do
      transition [:pending, :active] => :inactive
    end

    store_audit_trail
  end

  has_many :member_state_transitions

  include OneClickOrgs::UserAuthentication
  include OneClickOrgs::InvitationCode
  include OneClickOrgs::NotificationConsumer

  attr_accessor :send_welcome, :selected

  belongs_to :organisation
  belongs_to :member_class

  has_many :votes
  has_many :proposals, :foreign_key => 'proposer_member_id'
  has_many :board_resolutions, :foreign_key => 'proposer_member_id'

  has_many :ballots

  has_many :tasks

  has_many :resignations

  has_many :officerships, :foreign_key => 'officer_id'
  has_one :officership, :order => 'created_at DESC', :foreign_key => 'officer_id',
    :conditions => proc{[
      "(officerships.ended_on IS NULL OR officerships.ended_on > :now) AND officerships.elected_on <= :now",
      {:now => Time.now.utc}
    ]}
  has_one :office, :through => :officership

  has_many :directorships, :foreign_key => 'director_id', :inverse_of => :director
  has_one :directorship, :order => 'elected_on DESC', :foreign_key => 'director_id'

  has_one :share_account, :as => :owner

  scope :active, with_state(:active)
  scope :inactive, with_state(:inactive)
  scope :pending, with_state(:pending)

  scope :founders, lambda {|org| { :conditions => { :member_class_id => org.member_classes.where(:name => 'Founder').first } } }
  scope :founding_members, lambda {|org| { :conditions => { :member_class_id => org.member_classes.where(:name => 'Founding Member').first } } }
  scope :founder_members, lambda {|org| { :conditions => { :member_class_id => org.member_classes.where(:name => 'Founder Member').first } } }

  validates_presence_of :first_name, :last_name, :email

  validates_format_of :email, :with => /\A.*@.*\..*\Z/
  validates_each :email do |record, attribute, value|
    begin
      # Try to parse the email address
      Mail::Address.new(value)
    rescue Mail::Field::ParseError
      record.errors.add(attribute, 'is invalid.')
    end
  end

  validates_uniqueness_of :email, :scope => :organisation_id, :unless => :allow_duplicate_email?

  attr_accessor :allow_duplicate_email
  def allow_duplicate_email?
    !!allow_duplicate_email
  end

  attr_accessor :terms_and_conditions
  validates_acceptance_of :terms_and_conditions

  attr_accessor :certify_share_application
  attr_accessor :certify_age

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

  def ejected_or_resigned_at
    transition = member_state_transitions.where(["event = ? OR event = ?", 'reject', 'resign']).order('created_at DESC').first
    if transition
      transition.created_at
    else
      nil
    end
  end

  def eligible_to_vote?(proposal)
    organisation.member_eligible_to_vote?(self, proposal)
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

    tasks.where(:subject_type => proposal.class.base_class.name, :subject_id => proposal.id, :action => 'vote').each do |task|
      task.update_attribute(:completed_at, Time.now.utc)
    end
  end

  def inducted?
    !inducted_at.nil?
  end

  def to_event
    # TODO Push this knowledge somewhere more appropriate
    if inducted?
      {:timestamp => self.inducted_at, :object => self, :kind => :new_member}
    elsif organisation.is_a?(Coop)
      {:timestamp => self.created_at, :object => self, :kind => :new_member}
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

  def organisation_name
    organisation.try(:name)
  end

  # A member is a founding member if they were created before the association's
  # founding proposal, or if they are in an association that has not had a
  # founding proposal yet.
  def founding_member?
    return false unless organisation.is_a?(Association)

    fap = organisation.found_association_proposals.last
    if fap
      self.created_at < fap.creation_date
    else
      true
    end
  end

  def contact_details_present?
    email.present? && address.present? && phone.present?
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

  # SHARES

  def shares_count
    find_or_build_share_account.balance
  end

  def find_or_build_share_account
    share_account || build_share_account
  end

  def find_or_create_share_account
    share_account || create_share_account!
  end

  # FINDERS

  def self.find_by_name(name)
    find_by_first_name_and_last_name(*name.split(' '))
  end
end
