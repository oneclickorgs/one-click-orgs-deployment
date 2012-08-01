class GeneralMeeting < Meeting
  attr_accessible :start_time, :venue, :agenda, :certification, :existing_resolutions_attributes,
    :annual_general_meeting, :electronic_nominations, :nominations_closing_date,
    :electronic_voting, :voting_closing_date

  has_many :resolutions, :foreign_key => 'meeting_id'

  attr_accessor :certification, :annual_general_meeting
  attr_accessor :electronic_nominations, :nominations_closing_date,
    :electronic_voting, :voting_closing_date

  def existing_resolutions_attributes=(attributes)
    # The attributes received from the form will look something like this:
    # {"0"=>{"attached"=>"1", "id"=>"7"}, "1"=>{"attached"=>"0", "id"=>"9"}}
    # 
    # We want to find only the resolutions that have been attached, and
    # grab their IDs.

    return unless attributes.is_a?(Hash)

    ids_to_attach = attributes.values.select{|a| a['attached'] == '1'}.map{|a| a['id'].to_i}

    # TODO Resolution search should be scoped by organisation,
    # but organisation is not set yet when building this general meeting
    # in the form @organisation.general_meetings.build(attributes)
    resolutions_to_attach = ids_to_attach.map{|id| Resolution.find_by_id(id)}
    resolutions_to_attach.delete_if(&:nil?)
    resolutions << resolutions_to_attach

    attributes
  end

  def creation_notification_email_action
    :notify_general_meeting_creation
  end

  def members_to_notify
    organisation.members
  end

  def to_event
    {:timestamp => created_at, :object => self, :kind => :general_meeting}
  end

  # To fake multi-parameter date assignment for 'nominations_closing_date' attribute

  def column_for_attribute(attribute)
    case attribute.to_sym
    when :nominations_closing_date, :voting_closing_date
      Column.new.tap{|c| c.klass = Date}
    else
      super
    end
  end

  class Column
    attr_accessor :klass
  end

end
