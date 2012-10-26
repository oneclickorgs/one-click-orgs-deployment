class MemberTaskObserver < ActiveRecord::Observer
  observe :member

  def after_create(member)
    case member.organisation
    when Coop
      if member.pending?
        add_process_application_task_for_secretary(member)
      end
    end
  end

  def after_transition(member, transition)
    case transition.event
    when :resign
      case member.organisation
      when Coop
        add_process_resignation_task_for_secretary(member)
      end
    end
  end

protected

  def add_process_application_task_for_secretary(member)
    secretary = member.organisation.try(:secretary)
    return unless secretary

    secretary.tasks.create(:subject => member, :action => :process_application)
  end

  def add_process_resignation_task_for_secretary(member)
    secretary = member.organisation.try(:secretary)
    return unless secretary

    secretary.tasks.create(:subject => member, :action => :process_resignation)
  end
end
