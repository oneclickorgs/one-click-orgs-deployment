class AdministratorSessionsController < ApplicationController
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated
  skip_before_filter :prepare_notifications

  skip_before_filter :ensure_administrator_authenticated
  before_filter :ensure_administration_subdomain

  layout 'admin'

  def new
    @page_title = "Administrator Login"
  end

  def create
    administrator = Administrator.authenticate(params[:email], params[:password])
    if administrator
      log_in_administrator administrator

      flash[:notice] = "You have logged in."
      redirect_back_or_default
    else
      flash.now[:error] = "The email address or password entered were incorrect"
      render(:action => :new)
    end

  end
end
