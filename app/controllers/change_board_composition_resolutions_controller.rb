class ChangeBoardCompositionResolutionsController < ApplicationController
  def new
    @change_board_composition_resolution = ChangeBoardCompositionResolution.new(:organisation => co)

    respond_to do |format|
      format.html
      format.js
    end
  end
end
