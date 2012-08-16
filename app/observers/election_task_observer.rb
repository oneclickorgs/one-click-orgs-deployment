class ElectionTaskObserver < ActiveRecord::Observer
  observe :election

  def after_transition(election, transition)
    case transition.event
    when :close
      add_close_tasks_for_members(election)
    end
  end

protected

  def add_close_tasks_for_members(election)
    members = election.try(:organisation).try(:members)
    return unless members.present?
    members.each do |member|
      member.tasks.create(:subject => election, :action => :view_result)
    end
  end
end
