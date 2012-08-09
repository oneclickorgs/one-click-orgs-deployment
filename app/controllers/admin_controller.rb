class AdminController < ApplicationController
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated
  skip_before_filter :prepare_notifications

  before_filter :ensure_administrator_authenticated
  before_filter :ensure_administration_subdomain

  def index
  end
end
