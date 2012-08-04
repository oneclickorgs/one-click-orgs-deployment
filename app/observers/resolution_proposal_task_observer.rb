class ResolutionProposalTaskObserver < ActiveRecord::Observer
  observe :resolution_proposal

  def after_create(resolution_proposal)
    add_task_for_secretary(resolution_proposal)
  end

protected

  def add_task_for_secretary(resolution_proposal)
    secretary = resolution_proposal.organisation.try(:secretary)  
    return unless secretary

    secretary.tasks.create(:subject => resolution_proposal)
  end
end
