class OrganisationsController < ApplicationController
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated
  
  layout "setup"
  
  def new
    if Setting[:theme] == 'cooperatives_uk'
      redirect_to new_coop_path
      return
    end
  end
end
