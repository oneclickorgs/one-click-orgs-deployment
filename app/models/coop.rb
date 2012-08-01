require 'one_click_orgs/cast_to_boolean'

class Coop < Organisation
  include OneClickOrgs::CastToBoolean

  has_many :meetings, :foreign_key => 'organisation_id'
  has_many :board_meetings, :foreign_key => 'organisation_id'
  has_many :general_meetings, :foreign_key => 'organisation_id'
  has_many :annual_general_meetings, :foreign_key => 'organisation_id'
  
  has_many :resolutions, :foreign_key => 'organisation_id'
  has_many :board_resolutions, :foreign_key => 'organisation_id'

  has_many :change_meeting_notice_period_resolutions, :foreign_key => 'organisation_id'
  has_many :change_quorum_resolutions, :foreign_key => 'organisation_id'
  
  has_many :resolution_proposals, :foreign_key => 'organisation_id'

  has_many :offices, :foreign_key => 'organisation_id'
  has_many :officerships, :through => :offices

  has_many :elections, :foreign_key => 'organisation_id'

  # ATTRIBUTES

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
  
  def create_default_member_classes
    members = member_classes.find_or_create_by_name('Member')
    members.set_permission!(:resolution_proposal, true)
    members.set_permission!(:vote, true)
    
    founder_members = member_classes.find_or_create_by_name('Founder Member')
    
    directors = member_classes.find_or_create_by_name('Director')
    directors.set_permission!(:resolution, true)
    directors.set_permission!(:board_resolution, true)
    directors.set_permission!(:vote, true)
    directors.set_permission!(:meeting, true)
    
    secretaries = member_classes.find_or_create_by_name('Secretary')
    secretaries.set_permission!(:resolution, true)
    secretaries.set_permission!(:board_resolution, true)
    secretaries.set_permission!(:meeting, true)    
    secretaries.set_permission!(:constitution, true)
    secretaries.set_permission!(:vote, true)
  end
  
  def set_default_voting_period
    constitution.set_voting_period(14.days)
  end
  
  def member_eligible_to_vote?(member, proposal)
    true
  end
  
  def secretary
    member_classes.find_by_name!('Secretary').members.last
  end

  def directors
    members.where(['member_class_id = ?', member_classes.find_by_name!('Director').id])
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

end
