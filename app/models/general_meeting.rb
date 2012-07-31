class GeneralMeeting < Meeting
  attr_accessible :start_time, :venue, :agenda, :certification

  attr_accessor :certification

  def creation_notification_email_action
    :notify_general_meeting_creation
  end

  def members_to_notify
    organisation.members
  end

end
