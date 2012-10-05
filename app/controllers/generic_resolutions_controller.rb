class GenericResolutionsController < ApplicationController
  def new
    @resolution = co.resolutions.build
    respond_to do |format|
      format.html
      format.js
    end
  end
end
