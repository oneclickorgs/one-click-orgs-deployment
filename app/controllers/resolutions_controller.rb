class ResolutionsController < ApplicationController
  def new
    unless can?(:create, Resolution) || can?(:create, ExtraordinaryResolution)
      redirect_to root_path
      return
    end
    
    @resolution = co.resolutions.build
  end
end
