class GeneralMeetingTaskObserver < ActiveRecord::Observer
  observe :general_meeting,
    :annual_general_meeting

  def after_create(general_meeting)
    add_minute_task_for_secretary(general_meeting)
  end

  def after_save(general_meeting)
    if general_meeting.minuted?
      complete_minute_task_for_secretary(general_meeting)
    end
  end

protected

  def add_minute_task_for_secretary(general_meeting)
    secretary = general_meeting.organisation.try(:secretary)
    return unless secretary

    secretary.tasks.create(:subject => general_meeting, :action => :minute, :starts_on => general_meeting.happened_on)
  end

  def complete_minute_task_for_secretary(general_meeting)
    secretary = general_meeting.organisation.try(:secretary)
    return unless secretary

    secretary.tasks.current.where(
      :subject_type => 'Meeting',
      :subject_id => general_meeting.id,
      :action => 'minute'
    ).each do |task|
      task.complete!
    end
  end
end
