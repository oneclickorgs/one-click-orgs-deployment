class MemberTaskObserver < ActiveRecord::Observer
  observe :member

  def after_create(member)
    case member.organisation
    when Coop
      if member.pending?
        add_task_for_secretary(member)
      end
    end
  end

protected

  def add_task_for_secretary(member)
    secretary = member.organisation.try(:secretary)
    return unless secretary

    secretary.tasks.create(:subject => member, :action => :process_application)
  end
end
