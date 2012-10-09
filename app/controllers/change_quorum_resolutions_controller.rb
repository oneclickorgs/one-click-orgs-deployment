class ChangeQuorumResolutionsController < ApplicationController
  def new
    @change_quorum_resolution = co.change_quorum_resolutions.build

    respond_to do |format|
      format.html
      format.js
    end

  end

  def create
    @change_quorum_resolution = co.change_quorum_resolutions.build(params[:change_quorum_resolution])
    @change_quorum_resolution.proposer = current_user
    @change_quorum_resolution.draft = true
    @change_quorum_resolution.save!
    flash[:notice] = "A draft resolution to change the General Meeting quorum has been created."
    redirect_to meetings_path
  end
end
