class ChangeSingleShareholdingResolutionsController < ApplicationController
  def new
    @change_single_shareholding_resolution = ChangeSingleShareholdingResolution.new(:organisation => co)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
