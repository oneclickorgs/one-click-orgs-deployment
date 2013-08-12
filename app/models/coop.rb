require 'one_click_orgs/cast_to_boolean'

class Coop < Organisation
  include OneClickOrgs::CastToBoolean

  attr_accessible :reg_form_timing_factors, :reg_form_close_links,
    :reg_form_financial_year_end,
    :reg_form_signatories_attributes,
    :reg_form_main_contact_organisation_name, :reg_form_main_contact_name,
    :reg_form_main_contact_address, :reg_form_main_contact_phone,
    :reg_form_main_contact_email,
    :reg_form_financial_contact_name, :reg_form_financial_contact_phone,
    :reg_form_financial_contact_email,
    :reg_form_money_laundering_0_name,
    :reg_form_money_laundering_0_date_of_birth,
    :reg_form_money_laundering_0_address,
    :reg_form_money_laundering_0_postcode,
    :reg_form_money_laundering_0_residency_length,
    :reg_form_money_laundering_1_name,
    :reg_form_money_laundering_1_date_of_birth,
    :reg_form_money_laundering_1_address,
    :reg_form_money_laundering_1_postcode,
    :reg_form_money_laundering_1_residency_length,
    :reg_form_money_laundering_agreement

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

  has_one :share_account, :as => :owner
  has_many :withdrawals, :through => :share_account
  has_many :deposits, :through => :share_account

  # Returns true if the requirements for moving to the 'proposed' state
  # have been fulfilled.
  def can_propose?
    result = true

    result &&= members.active.count >= 3
    result &&= directors.count >= 3
    result &&= !!secretary
    result &&= rules_filled?
    result &&= registration_form_filled?

    result
  end

  def founder_members
    members.founder_members(self)
  end

  after_create :create_default_offices
  after_create :set_default_user_and_director_clauses
  after_create :create_share_account_if_necessary
  after_create :set_default_clauses

  def member_count_for_proposal(proposal)
    # TODO check that this is correct
    members.active.count
  end

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

  def single_shareholding=(new_single_shareholding)
    clauses.build(:name => :single_shareholding, :boolean_value => !!new_single_shareholding)
    @single_shareholding = !!new_single_shareholding
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

  def membership_application_text
    @membership_application_text ||= clauses.get_text(:membership_application_text)
  end

  def membership_application_text=(new_membership_application_text)
    clauses.build(:name => :membership_application_text, :text_value => new_membership_application_text)
    @membership_application_text = new_membership_application_text
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
    founder_members.set_permission!(:directorship, true)
    founder_members.set_permission!(:officership, true)

    directors = member_classes.find_or_create_by_name('Director')
    directors.set_permission!(:resolution, true)
    directors.set_permission!(:board_resolution, true)
    directors.set_permission!(:vote, true)
    directors.set_permission!(:meeting, true)
    directors.set_permission!(:board_meeting, true)
    directors.set_permission!(:share_account, true)

    secretaries = member_classes.find_or_create_by_name('Secretary')
    secretaries.set_permission!(:resolution, true)
    secretaries.set_permission!(:board_resolution, true)
    secretaries.set_permission!(:meeting, true)
    secretaries.set_permission!(:vote, true)
    secretaries.set_permission!(:board_meeting, true)
    secretaries.set_permission!(:member, true)
    secretaries.set_permission!(:organisation, true)
    secretaries.set_permission!(:directorship, true)
    secretaries.set_permission!(:officership, true)
    secretaries.set_permission!(:share_account, true)
    secretaries.set_permission!(:share_transaction, true)

    external_directors = member_classes.find_or_create_by_name('External Director')
    external_directors.set_permission!(:board_resolution, true)
    external_directors.set_permission!(:board_meeting, true)
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

  def set_default_clauses
    self.quorum_number = 3
    self.quorum_percentage = 25
    self.meeting_notice_period = 14
    self.save!
  end

  def destroy_pending_state_member_classes
  end

  def create_share_account_if_necessary
    unless share_account
      create_share_account!
    end
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
      'member_class_id IN (?)',
      [
        member_classes.find_by_name!('Director').id,
        member_classes.find_by_name!('Secretary').id,
        member_classes.find_by_name!('External Director').id
      ]
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
        raise e.errors.map{|error| [error.exception, error.attribute]}.inspect
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

  def meeting_classes
    [GeneralMeeting, AnnualGeneralMeeting, BoardMeeting]
  end

  def build_minute(attributes={})
    Minute.new(attributes).tap{|m|
      m.organisation = self
    }
  end

  # True if the minimum required fields in the Rules have been filled in.
  def rules_filled?
    name.present? &&
      registered_office_address.present? &&
      objectives.present?
  end

  # Registration form

  def reg_form_timing_factors
    @reg_form_timing_factors ||= clauses.get_text('reg_form_timing_factors')
  end

  def reg_form_timing_factors=(new_reg_form_timing_factors)
    new_reg_form_timing_factors = ' ' if new_reg_form_timing_factors.blank?
    clauses.build(:name => 'reg_form_timing_factors', :text_value => new_reg_form_timing_factors)
    @reg_form_timing_factors = new_reg_form_timing_factors
  end

  def reg_form_close_links
    @reg_form_close_links ||= clauses.get_text('reg_form_close_links')
  end

  def reg_form_close_links=(new_reg_form_close_links)
    new_reg_form_close_links = ' ' if new_reg_form_close_links.blank?
    clauses.build(:name => 'reg_form_close_links', :text_value => new_reg_form_close_links)
    @reg_form_close_links = new_reg_form_close_links
  end

  def reg_form_financial_year_end
    @reg_form_financial_year_end ||= clauses.get_text('reg_form_financial_year_end')
  end

  def reg_form_financial_year_end=(new_reg_form_financial_year_end)
    new_reg_form_financial_year_end = ' ' if new_reg_form_financial_year_end.blank?
    clauses.build(:name => 'reg_form_financial_year_end', :text_value => new_reg_form_financial_year_end)
    @reg_form_finacial_year_end = new_reg_form_financial_year_end
  end

  def reg_form_signatories_attributes=(attributes)
    attributes = attributes.reject{|k, v| v['selected'] != '1'}
    signatory_ids = []
    attributes.each{|k, v| signatory_ids[k.to_i] = v['id'].to_i}
    signatory_ids = signatory_ids.compact[0..2]

    signatories = signatory_ids.map{|id| members.find(id)}

    self.signatories = signatories
  end

  def signatories
    [
      clauses.get_integer(:reg_form_signatories_0),
      clauses.get_integer(:reg_form_signatories_1),
      clauses.get_integer(:reg_form_signatories_2)
    ].map{|id| members.find_by_id(id)}.compact
  end

  def signatories=(new_signatories)
    clauses.set_integer!(:reg_form_signatories_0, new_signatories[0].id) if new_signatories[0]
    clauses.set_integer!(:reg_form_signatories_1, new_signatories[1].id) if new_signatories[1]
    clauses.set_integer!(:reg_form_signatories_2, new_signatories[2].id) if new_signatories[2]
  end

  def reg_form_money_laundering_agreement=(new_money_laundering_agreement)
    new_money_laundering_agreement = cast_to_boolean(new_money_laundering_agreement)
    clauses.build(:name => :reg_form_money_laundering_agreement, :boolean_value => new_money_laundering_agreement)
    @reg_form_money_laundering_agreement = new_money_laundering_agreement
  end

  def reg_form_money_laundering_agreement
    if @reg_form_money_laundering_agreement.nil?
      @reg_form_money_laundering_agreement = clauses.get_boolean(:reg_form_money_laundering_agreement)
    end
    @reg_form_money_laundering_agreement
  end

  def reg_form_money_laundering_agreement?
    !!reg_form_money_laundering_agreement
  end

  # Define some more text attributes for the registration form.
  [
    :main_contact_organisation_name,
    :main_contact_name,
    :main_contact_address,
    :main_contact_phone,
    :main_contact_email,
    :financial_contact_name,
    :financial_contact_phone,
    :financial_contact_email,
    :money_laundering_0_name,
    :money_laundering_0_date_of_birth,
    :money_laundering_0_address,
    :money_laundering_0_postcode,
    :money_laundering_0_residency_length,
    :money_laundering_1_name,
    :money_laundering_1_date_of_birth,
    :money_laundering_1_address,
    :money_laundering_1_postcode,
    :money_laundering_1_residency_length
  ].each do |reg_form_attr_name|
    class_eval("
      def reg_form_#{reg_form_attr_name}=(new_#{reg_form_attr_name})
        clauses.build(:name => :reg_form_#{reg_form_attr_name}, :text_value => new_#{reg_form_attr_name})
        @reg_form_#{reg_form_attr_name} = new_#{reg_form_attr_name}
      end

      def reg_form_#{reg_form_attr_name}
        @reg_form_#{reg_form_attr_name} ||= clauses.get_text(:reg_form_#{reg_form_attr_name})
      end
    ")
  end



  def registration_form_filled?
    clauses.get_integer(:reg_form_signatories_0) &&
      clauses.get_integer(:reg_form_signatories_1) &&
      clauses.get_integer(:reg_form_signatories_2)
  end

  # The lesser of 10% of the membership and 100 members is required to force a resolution.
  def members_required_to_force_resolution
    ten_percent_of_membership = (members.active.count / 10.0).ceil
    if ten_percent_of_membership < 100
      ten_percent_of_membership
    else
      100
    end
  end

  def self.run_daily_job
    # Find all Coop members who have not attained the minimum shareholding within 12 months
    # of membership.
    all.each do |coop|
      if !coop.single_shareholding && coop.minimum_shareholding
        old_members = coop.members.where(["inducted_at <= ?", 12.months.ago])
        old_members.select{|m| m.find_or_build_share_account.balance < coop.minimum_shareholding}.each do |member|
          unless member.tasks.current.where(:subject_id => member.id, :subject_type => 'Member', :action => :minimum_shareholding_missed).first
            member.tasks.create(:subject => member, :action => :minimum_shareholding_missed)
            coop.secretary.tasks.create(:subject => member, :action => :minimum_shareholding_missed)
          end
        end
      end
    end
  end
end
