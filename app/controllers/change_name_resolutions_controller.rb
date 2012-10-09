class ChangeNameResolutionsController < ApplicationController
  def new
    @change_name_resolution = ChangeNameResolution.new(:organisation => co)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
