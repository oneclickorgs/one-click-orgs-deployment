class ChangeMembershipCriteriaResolutionsController < ApplicationController
  def new
    @change_membership_criteria_resolution = ChangeMembershipCriteriaResolution.new(:organisation => co)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
