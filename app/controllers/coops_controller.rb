class CoopsController < ApplicationController
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated
  
  layout "setup"
  
  def new
  end
end
