class ChangeCommonOwnershipResolutionsController < ApplicationController
  def new
    @change_common_ownership_resolution = ChangeCommonOwnershipResolution.new(:organisation => co)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
