class SetupController < ApplicationController
  skip_before_filter :ensure_set_up
  before_filter :ensure_not_set_up_yet
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated
  skip_before_filter :ensure_member_active
  #skip_before_filter :ensure_organisation_active
  skip_before_filter :ensure_member_inducted
  skip_before_filter :prepare_notifications
  
  layout 'setup'
  
  def index
    @base_domain = request.host_with_port
    @signup_domain = request.host_with_port
  end
  
  def create_domains
    @base_domain = params[:base_domain]
    @signup_domain = params[:signup_domain]
    if @base_domain.present? && @signup_domain.present?
      Setting[:base_domain] = @base_domain
      Setting[:signup_domain] = @signup_domain
      flash[:notice] = "Domains set. Now you can make an organisation."
      redirect_to(new_organisation_url(:host => Setting[:signup_domain]))
    else
      flash.now[:error] = "You must choose both a base domain and a sign-up domain."
      render(:action => :index)
    end
  end
  
  def set_single_organisation_mode
    Setting[:single_organisation_mode] = "true"
    Setting[:base_domain] = request.host_with_port
    Setting[:signup_domain] = request.host_with_port
    redirect_to(new_organisation_path)
  end

  protected

  def ensure_not_set_up_yet
    if OneClickOrgs::Setup.complete?
      redirect_to('/')
    end
  end
  
end
