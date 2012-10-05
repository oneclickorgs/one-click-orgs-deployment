class ResolutionsController < ApplicationController
  def new
    unless can?(:create, Resolution) || can?(:create, ExtraordinaryResolution)
      redirect_to root_path
      return
    end

    @resolution = co.resolutions.build
  end

  def create
    @resolution = current_organisation.resolutions.build(params[:resolution])
    @resolution.proposer = current_user
    @resolution.save!
    redirect_to proposals_path
  end

  def show
    @resolution = co.resolutions.find(params[:id])
    @comments = @resolution.comments
    @comment = Comment.new
  end
end
