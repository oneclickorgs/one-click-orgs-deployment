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

  def notice_period_increased?
    meeting_notice_period.to_i > organisation.constitution.meeting_notice_period
  end

  def creation_success_message
    if open?
      "A proposal to #{notice_period_increased? ? 'increase' : 'decrease'} the General Meeting notice period has been opened for electronic voting."
    elsif draft?
      "A draft proposal to #{notice_period_increased? ? 'increase' : 'decrease'} the General Meeting notice period has been saved."
    end
  end

end
