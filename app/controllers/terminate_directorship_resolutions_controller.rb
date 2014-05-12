class TerminateDirectorshipResolutionsController < ApplicationController
  def new
    @terminate_directorship_resolution = co.terminate_directorship_resolutions.build
    @directors_for_select = co.directors.map{|d| [d.name, d.id]}
    respond_to do |format|
      format.html
      format.js
    end
  end
end
