class ChangeRegisteredOfficeAddressResolutionsController < ApplicationController
  def new
    @change_registered_office_address_resolution = ChangeRegisteredOfficeAddressResolution.new(:organisation => co)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
