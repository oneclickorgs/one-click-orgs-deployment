class GeneralMeetingTaskObserver < ActiveRecord::Observer
  observe :general_meeting,
    :annual_general_meeting

  def after_create(general_meeting)
    add_minute_task_for_secretary(general_meeting)
  end

protected
  
  def add_minute_task_for_secretary(general_meeting)
    secretary = general_meeting.organisation.try(:secretary)
    return unless secretary

    secretary.tasks.create(:subject => general_meeting, :action => :minute, :starts_on => general_meeting.happened_on)
  end
end
