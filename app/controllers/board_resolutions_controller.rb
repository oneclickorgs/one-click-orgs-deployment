class BoardResolutionsController < ApplicationController
  def new
    @board_resolution = co.board_resolutions.build
  end
  
  def create
    @board_resolution = co.board_resolutions.build(params[:board_resolution])
    @board_resolution.proposer = current_user
    @board_resolution.save!
    redirect_to proposals_path
  end
end
