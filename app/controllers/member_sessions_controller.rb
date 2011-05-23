class MemberSessionsController < ApplicationController
  skip_before_filter :ensure_authenticated
  skip_before_filter :ensure_member_active_or_pending
  skip_before_filter :ensure_member_inducted
  skip_before_filter :prepare_notifications
  
  before_filter :redirect_to_root_if_logged_in, :only => :new
  
  def new
    @page_title = "Login"
  end
  
  def create
    user = co.members.authenticate(params[:email], params[:password])
    if user
      log_in user
      
      flash[:notice] = "Welcome back, #{current_user.name}!"
      redirect_back_or_default
    else
      flash.now[:error] = "The email address or password entered were incorrect"
      render(:action => :new)
    end
  end
  
  def destroy
    reset_session
    flash[:notice] = "Logged Out"
    redirect_to(root_path)
  end
  
private
  
  def redirect_to_root_if_logged_in
    redirect_to root_path if current_user
  end
end
