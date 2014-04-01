class SetupController < ApplicationController
  skip_before_filter :ensure_set_up
  before_filter :ensure_not_set_up_yet
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated
  skip_before_filter :ensure_member_active_or_pending
  skip_before_filter :ensure_member_inducted
  skip_before_filter :prepare_notifications
  
  layout 'setup'
  
  def index
    redirect_to(action: :domains)
  end

  def domains
    @base_domain = request.host_with_port
    @signup_domain = request.host_with_port
  end
  
  def create_domains
    @base_domain = params[:base_domain]
    @signup_domain = params[:signup_domain]
    if @base_domain.present? && @signup_domain.present?
      Setting[:base_domain] = @base_domain
      Setting[:signup_domain] = @signup_domain
      redirect_to(action: :organisation_types)
    else
      flash.now[:error] = "You must choose both a base domain and a sign-up domain."
      render(:action => :domains)
    end
  end

  def set_organisation_types
    if params[:association] == '1'
      Setting[:association_enabled] = 'true'
    else
      Setting[:association_enabled] = 'false'
    end
    if params[:company] == '1'
      Setting[:company_enabled] = 'true'
    else
      Setting[:company_enabled] = 'false'
    end
    if params[:coop] == '1'
      Setting[:coop_enabled] = 'true'
    else
      Setting[:coop_enabled] = 'false'
    end
    redirect_to(new_organisation_url(host: Setting[:signup_domain]))
  end
  
  def set_single_organisation_mode
    Setting[:single_organisation_mode] = "true"
    Setting[:base_domain] = request.host_with_port
    Setting[:signup_domain] = request.host_with_port
    redirect_to(new_association_path)
  end

  protected

  def ensure_not_set_up_yet
    if OneClickOrgs::Setup.complete?
      redirect_to('/')
    end
  end
  
end
