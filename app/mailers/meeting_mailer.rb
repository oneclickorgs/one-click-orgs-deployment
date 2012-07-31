class MeetingMailer < OcoMailer
  def notify_creation(member, meeting)
    default_url_options[:host] = meeting.organisation.domain(:only_host => true)
    
    @member = member
    @meeting = meeting
    
    create_mail(
      @meeting.organisation.name,
      @member.email,
      "New minutes submitted for #{@meeting.organisation.name}"
    )
  end

  def notify_board_meeting_creation(member, meeting)
    default_url_options[:host] = meeting.organisation.domain(:only_host => true)

    @member = member
    @meeting = meeting

    create_mail(
      @meeting.organisation.name,
      @member.email,
      "A new Board Meeting has been convened"
    )
  end

  def notify_general_meeting_creation(member, meeting)
    default_url_options[:host] = meeting.organisation.domain(:only_host => true)

    @member = member
    @meeting = meeting

    create_mail(
      @meeting.organisation.name,
      @member.email,
      "A new General Meeting has been convened"
    )
  end
end
