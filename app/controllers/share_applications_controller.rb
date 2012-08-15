class ShareApplicationsController < ApplicationController
  def new
    @share_application = ShareApplication.new
  end

  def create
    @share_application = ShareApplication.new(params[:share_application])
    @share_application.member = current_user
    @share_application.save!
    redirect_to shares_path
  end
end
