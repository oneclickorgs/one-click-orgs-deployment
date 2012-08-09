class Admin::CoopsController < ApplicationController
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated
  skip_before_filter :prepare_notifications

  before_filter :ensure_administrator_authenticated
  before_filter :ensure_administration_subdomain

  layout 'admin'

  def index
    @pending_coops = Coop.pending.order("created_at DESC")
    @proposed_coops = Coop.proposed.order("created_at DESC")
    @active_coops = Coop.active.order("created_at DESC")
  end

  def found
    @coop = Coop.find(params[:id])
    @coop.found!
    flash[:notice] = "#{@coop.name} is now active."
    redirect_to admin_coops_path
  end
end
