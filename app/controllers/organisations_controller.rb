class OrganisationsController < ApplicationController
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated
  
  layout "setup"
  
  def new
    @association_enabled = (Setting[:association_enabled] == 'true')
    @company_enabled = (Setting[:company_enabled] == 'true')
    @coop_enabled = (Setting[:coop_enabled] == 'true')

    # If only one type of organisation is enabled, redirect directly to that organisation
    if @association_enabled && !@company_enabled && !@coop_enabled
      redirect_to(new_association_path) and return
    elsif !@association_enabled && @company_enabled && !@coop_enabled
      redirect_to(new_company_path) and return
    elsif !@association_enabled && !@company_enabled && @coop_enabled
      redirect_to(new_coop_path) and return
    end
  end
end
