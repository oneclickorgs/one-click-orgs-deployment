class ConstitutionsController < ApplicationController
  before_filter :find_constitution

  def show
    case co
    when Coop
      @page_title = "Rules"
      @header_left = "Co-operatives UK Multi-stakeholder Co-operative Model Rules (One-Click Model)"
      @header_right = nil
      @stylesheet = File.join(Rails.root, 'app', 'assets', 'stylesheets', 'coop_rules_pdf.css')

      @signatories = co.signatories
      @secretary = co.secretary
      @acceptance = @constitution.acceptance
    else
      @page_title = "Constitution"
    end

    respond_to do |format|
      format.html
      format.pdf {
        generate_pdf(@page_title,
          :header_left => @header_left,
          :header_right => @header_right,
          :stylesheet => @stylesheet
        )
      }
    end
  end

  def edit
    @page_title = "Amendments"

    case co
    when Association
      @allow_editing = can?(:update, Constitution) || can?(:create, ConstitutionProposal)

      if can?(:update, Constitution)
        @constitution_wrapper = ConstitutionWrapper.new(:constitution => @constitution)
      else
        @constitution_proposal_bundle = co.build_constitution_proposal_bundle
      end
    when Coop
      if can?(:update, Constitution)
        @allow_editing = true
        @constitution_wrapper = ConstitutionWrapper.new(:constitution => @constitution)
      elsif can?(:create, Resolution) || can?(:create, ResolutionProposal)
        @allow_editing = true
        @constitution_proposal_bundle = co.build_constitution_proposal_bundle
      end
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
