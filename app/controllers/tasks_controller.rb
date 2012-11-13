class TasksController < ApplicationController
  def dismiss
    @task = current_user.tasks.find(params[:id])
    @task.dismiss!
    redirect_to :back
  end
end
