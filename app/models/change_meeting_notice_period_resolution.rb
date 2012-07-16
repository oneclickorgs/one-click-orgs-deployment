class ChangeMeetingNoticePeriodResolution < Resolution
  attr_accessible :pass_immediately, :meeting_notice_period

  def meeting_notice_period
    parameters['meeting_notice_period']
  end
  
  def meeting_notice_period=(meeting_notice_period)
    self.parameters['meeting_notice_period'] = meeting_notice_period.to_i
  end

  def set_default_title
    self.title ||= "Change notice period for General Meetings to #{meeting_notice_period} clear days"
  end

  def enact!
    organisation.constitution.meeting_notice_period = parameters['meeting_notice_period']
  end

end
