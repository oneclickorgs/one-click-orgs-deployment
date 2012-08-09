class MeetingMailerObserver < ActiveRecord::Observer
  observe :meeting, :general_meeting, :annual_general_meeting, :board_meeting

  def after_create(meeting)
    send_creation_notification_emails(meeting)
  end

protected

  def send_creation_notification_emails(meeting)
    if meeting.creation_notification_email_action && meeting.members_to_notify
      meeting.members_to_notify.each do |member|
        MeetingMailer.send(meeting.creation_notification_email_action, member, meeting).deliver
      end
    end
  end

end
