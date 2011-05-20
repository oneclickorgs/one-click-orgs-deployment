class ConstitutionsController < ApplicationController
  before_filter :find_constitution
  
  def show
    @page_title = "Constitution"
    
    respond_to do |format|
      format.html
      format.pdf {
        generate_pdf(@page_title)
      }
    end
  end
end
