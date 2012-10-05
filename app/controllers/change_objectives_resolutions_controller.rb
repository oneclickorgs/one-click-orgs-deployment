class ChangeObjectivesResolutionsController < ApplicationController
  def new
    @change_objectives_resolution = ChangeObjectivesResolution.new(:organisation => co)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
