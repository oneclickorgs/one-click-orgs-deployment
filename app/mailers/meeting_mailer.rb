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
end
