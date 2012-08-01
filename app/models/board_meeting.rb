class BoardMeeting < Meeting
  attr_accessible :start_time, :venue, :agenda

  def creation_notification_email_action
    :notify_board_meeting_creation
  end

  def members_to_notify
    organisation.directors
  end

  def to_event
    {:timestamp => created_at, :object => self, :kind => :board_meeting}
  end
end
