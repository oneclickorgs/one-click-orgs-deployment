require 'one_click_orgs/cast_to_boolean'

class Coop < Organisation
  include OneClickOrgs::CastToBoolean

  state_machine :initial => :pending do
    event :propose do
      transition :pending => :proposed
    end

    event :found do
      transition :proposed => :active
    end

    event :reject_founding do
      transition :proposed => :pending
    end

    after_transition :proposed => :active, :do => :destroy_pending_state_member_classes
  end

  scope :active, with_state(:active)
  scope :proposed, with_state(:proposed)
  scope :pending, with_state(:pending)

  has_many :meetings, :foreign_key => 'organisation_id'
  has_many :board_meetings, :foreign_key => 'organisation_id'
  has_many :general_meetings, :foreign_key => 'organisation_id'
  has_many :annual_general_meetings, :foreign_key => 'organisation_id'

  has_many :resolutions, :foreign_key => 'organisation_id'
  has_many :board_resolutions, :foreign_key => 'organisation_id'

  has_many :change_meeting_notice_period_resolutions, :foreign_key => 'organisation_id'
  has_many :change_quorum_resolutions, :foreign_key => 'organisation_id'
  has_many :change_text_resolutions, :foreign_key => 'organisation_id'
  has_many :change_boolean_resolutions, :foreign_key => 'organisation_id'
  has_many :change_integer_resolutions, :foreign_key => 'organisation_id'

  has_many :resolution_proposals, :foreign_key => 'organisation_id'

  has_many :offices, :foreign_key => 'organisation_id'
  has_many :officerships, :through => :offices
  has_many :officers, :through => :officerships

  has_many :directorships, :foreign_key => 'organisation_id'

  has_many :elections, :foreign_key => 'organisation_id'

  def founder_members
    members.founder_members(self)
  end

  after_create :create_default_offices
  after_create :set_default_user_and_director_clauses

  # ATTRIBUTES / CLAUSES

  def meeting_notice_period=(new_meeting_notice_period)
    clauses.set_integer!(:meeting_notice_period, new_meeting_notice_period)
  end

  def meeting_notice_period
    clauses.get_integer(:meeting_notice_period)
  end

  def quorum_number=(new_quorum_number)
    clauses.set_integer!(:quorum_number, new_quorum_number)
  end

  def quorum_number
    clauses.get_integer(:quorum_number)
  end

  def quorum_percentage=(new_quorum_percentage)
    clauses.set_integer!(:quorum_percentage, new_quorum_percentage)
  end

  def quorum_percentage
    clauses.get_integer(:quorum_percentage)
  end

  def objectives
    @objectives ||= clauses.get_text('organisation_objectives')
  end

  def objectives=(objectives)
    clauses.build(:name => 'organisation_objectives', :text_value => objectives)
    @objectives = objectives
  end

  def registered_office_address
    @registered_office_address ||= clauses.get_text('registered_office_address')
  end

  def registered_office_address=(registered_office_address)
    clauses.build(:name => 'registered_office_address', :text_value => registered_office_address)
    @registered_office_address = registered_office_address
  end

  def max_user_directors
    @max_user_directors ||= clauses.get_integer('max_user_directors')
  end

  def max_user_directors=(new_max_user_directors)
    clauses.build(:name => :max_user_directors, :integer_value => new_max_user_directors)
    @max_user_directors = new_max_user_directors
  end

  def max_employee_directors
    @max_employee_directors ||= clauses.get_integer('max_employee_directors')
  end

  def max_employee_directors=(new_max_employee_directors)
    clauses.build(:name => :max_employee_directors, :integer_value => new_max_employee_directors)
    @max_employee_directors = new_max_employee_directors
  end

  def max_supporter_directors
    @max_supporter_directors ||= clauses.get_integer('max_supporter_directors')
  end

  def max_supporter_directors=(new_max_supporter_directors)
    clauses.build(:name => :max_supporter_directors, :integer_value => new_max_supporter_directors)
    @max_supporter_directors = new_max_supporter_directors
  end

  def max_producer_directors
    @max_producer_directors ||= clauses.get_integer('max_producer_directors')
  end

  def max_producer_directors=(new_max_producer_directors)
    clauses.build(:name => :max_producer_directors, :integer_value => new_max_producer_directors)
    @max_producer_directors = new_max_producer_directors
  end

  def max_consumer_directors
    @max_consumer_directors ||= clauses.get_integer('max_consumer_directors')
  end

  def max_consumer_directors=(new_max_consumer_directors)
    clauses.build(:name => :max_consumer_directors, :integer_value => new_max_consumer_directors)
    @max_consumer_directors = new_max_consumer_directors
  end

  def user_members
    @user_members ||= clauses.get_boolean('user_members')
  end

  def user_members=(new_user_members)
    clauses.build(:name => :user_members, :boolean_value => new_user_members)
    @user_members = new_user_members
  end

  def employee_members
    @employee_members ||= clauses.get_boolean('employee_members')
  end

  def employee_members=(new_employee_members)
    clauses.build(:name => :employee_members, :boolean_value => new_employee_members)
    @employee_members = new_employee_members
  end

  def supporter_members
    @supporter_members ||= clauses.get_boolean('supporter_members')
  end

  def supporter_members=(new_supporter_members)
    clauses.build(:name => :supporter_members, :boolean_value => new_supporter_members)
    @supporter_members = new_supporter_members
  end

  def producer_members
    @producer_members ||= clauses.get_boolean('producer_members')
  end

  def producer_members=(new_producer_members)
    clauses.build(:name => :producer_members, :boolean_value => new_producer_members)
    @producer_members = new_producer_members
  end

  def consumer_members
    @consumer_members ||= clauses.get_boolean('consumer_members')
  end

  def consumer_members=(new_consumer_members)
    clauses.build(:name => :consumer_members, :boolean_value => new_consumer_members)
    @consumer_members = new_consumer_members
  end

  def single_shareholding
    @single_shareholding ||= clauses.get_boolean('single_shareholding')
  end

  def common_ownership
    @common_ownership ||= clauses.get_boolean('common_ownership')
  end

  def share_value=(new_share_value)
    clauses.build(:name => :share_value, :integer_value => new_share_value.to_i)
    @share_value = new_share_value.to_i
  end

  # Share value in pennies. Defaults to 100.
  def share_value
    @share_value ||= (clauses.get_integer('share_value') || 100)
  end

  def share_value_in_pounds=(new_share_value_in_pounds)
    new_share_value_in_pounds = new_share_value_in_pounds.to_f
    new_share_value = (new_share_value_in_pounds * 100.0).to_i
    self.share_value = new_share_value
  end

  def share_value_in_pounds
    share_value.to_f / 100.0
  end

  def minimum_shareholding=(new_minimum_shareholding)
    new_minimum_shareholding = new_minimum_shareholding.to_i
    clauses.build(:name => :minimum_shareholding, :integer_value => new_minimum_shareholding)
    @minimum_shareholding = new_minimum_shareholding
  end

  def minimum_shareholding
    @minimum_shareholding ||= (clauses.get_integer('minimum_shareholding') || 1)
  end

  def interest_rate
    @interest_rate ||= clauses.get_decimal('interest_rate')
  end

  def interest_rate=(new_interest_rate)
    new_interest_rate = new_interest_rate.to_f
    clauses.build(:name => :interest_rate, :decimal_value => new_interest_rate)
    @interest_rate = new_interest_rate
  end

  # SETUP

  def create_default_member_classes
    members = member_classes.find_or_create_by_name('Member')
    members.set_permission!(:resolution_proposal, true)
    members.set_permission!(:vote, true)

    founder_members = member_classes.find_or_create_by_name('Founder Member')
    founder_members.set_permission!(:constitution, true)
    founder_members.set_permission!(:organisation, true)
    founder_members.set_permission!(:founder_member, true)

    directors = member_classes.find_or_create_by_name('Director')
    directors.set_permission!(:resolution, true)
    directors.set_permission!(:board_resolution, true)
    directors.set_permission!(:vote, true)
    directors.set_permission!(:meeting, true)
    directors.set_permission!(:board_meeting, true)

    secretaries = member_classes.find_or_create_by_name('Secretary')
    secretaries.set_permission!(:resolution, true)
    secretaries.set_permission!(:board_resolution, true)
    secretaries.set_permission!(:meeting, true)
    secretaries.set_permission!(:vote, true)
    secretaries.set_permission!(:board_meeting, true)
    secretaries.set_permission!(:member, true)
    secretaries.set_permission!(:organisation, true)
  end

  def create_default_offices
    offices.find_or_create_by_title('Secretary')
    offices.find_or_create_by_title('Chairperson')
  end

  def set_default_voting_period
    constitution.set_voting_period(14.days)
  end

  def set_default_user_and_director_clauses
    # TODO Verify these are sensible defaults for the Rules
    self.user_members = true
    self.employee_members = true
    self.supporter_members = true
    self.producer_members = true
    self.consumer_members = true

    self.max_user_directors = 3
    self.max_employee_directors = 3
    self.max_supporter_directors = 3
    self.max_producer_directors = 3
    self.max_consumer_directors = 3

    self.save!
  end

  def destroy_pending_state_member_classes
  end

  def member_eligible_to_vote?(member, proposal)
    true
  end

  def secretary
    secretary_member_class = member_classes.find_by_name('Secretary')
    secretary_member_class ? secretary_member_class.members.last : nil
  end

  def directors
    members.where([
      'member_class_id = ? OR member_class_id=?',
      member_classes.find_by_name!('Director').id, member_classes.find_by_name!('Secretary').id
    ])
  end

  def build_directorship(attributes={})
    Directorship.new({:organisation => self}.merge(attributes))
  end

  def directors_retiring
    # TODO expand this to full rules of retirement
    directors
  end

  def build_general_meeting_or_annual_general_meeting(attributes={})
    attributes = attributes.dup.with_indifferent_access
    agm = cast_to_boolean(attributes.delete(:annual_general_meeting))

    if agm
      begin
        annual_general_meetings.build(attributes)
      rescue ActiveRecord::MultiparameterAssignmentErrors => e
        raise e.errors.map{|e| [e.exception, e.attribute]}.inspect
      end
    else
      general_meetings.build(attributes)
    end
  end

  def welcome_email_action
    if pending?
      :welcome_coop_founding_member
    elsif active?
      :welcome_coop_new_member
    end
  end

  def build_founder_member(attributes={})
    FounderMember.new(attributes).tap{|m|
      m.organisation = self
      m.member_class = member_classes.find_by_name("Founder Member")
    }
  end
end
