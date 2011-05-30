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
  
  def edit
    @page_title = "Amendments"
    
    @allow_editing = can?(:update, Constitution) || can?(:create, ConstitutionProposal)
    
    if can?(:update, Constitution)
      @constitution_wrapper = ConstitutionWrapper.new(:constitution => @constitution)
    else
      @constitution_proposal_bundle = co.build_constitution_proposal_bundle
    end
  end
  
  def update
    authorize! :update, Constitution
    
    @constitution_wrapper = ConstitutionWrapper.new(:constitution => @constitution)
    if @constitution_wrapper.update_attributes(params[:constitution])
      redirect_to(constitution_path, :notice => "Constitutional changes were made")
    else
      @page_title = "Amendments"
      @allow_editing = true # We have already authorized that the user can update a Constitution
      render(:action => :edit)
    end
  end
end
