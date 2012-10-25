class ResolutionTaskObserver < ActiveRecord::Observer
  observe :resolution

  def after_create(resolution)
    case resolution.state
    when 'open'
      add_vote_task_for_members(resolution)
    end
  end

  def after_transition(resolution, transition)
    case transition
    when :start
      add_vote_task_for_members(resolution)
    end
  end

protected

  def add_vote_task_for_members(resolution)
    members = resolution.organisation.members.active
    members.each do |member|
      member.tasks.create(:subject => resolution, :action => :vote)
    end
  end
end
