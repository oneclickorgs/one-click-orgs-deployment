class Admin::CoopsController < AdminController
  def index
    @pending_coops = Coop.pending.order("created_at DESC")
    @proposed_coops = Coop.proposed.order("created_at DESC")
    @active_coops = Coop.active.order("created_at DESC")
  end

  def show
    @coop = Coop.find(params[:id])
  end

  def found
    @coop = Coop.find(params[:id])
    @coop.found!
    flash[:notice] = "#{@coop.name} is now active."
    redirect_to admin_coops_path
  end
end
