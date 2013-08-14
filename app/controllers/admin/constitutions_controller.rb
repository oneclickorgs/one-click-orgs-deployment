class Admin::ConstitutionsController < AdminController
  # TODO Fix duplication between this and ::ConstitutionsController

  def show
    find_constitution

    case @organisation
    when Coop
      @page_title = "Rules"
      @header_left = "Co-operatives UK Multi-stakeholder Co-operative Model Rules (One-Click Model)"
      @header_right = nil
      @stylesheet = File.join(Rails.root, 'app', 'assets', 'stylesheets', 'coop_rules_pdf.css')

      @signatories = @organisation.signatories
      @secretary = @organisation.secretary
    else
      @page_title = "Constitution"
    end

    respond_to do |format|
      format.html
      format.pdf {
        generate_pdf(@page_title,
          :organisation => @organisation,
          :header_left => @header_left,
          :header_right => @header_right,
          :stylesheet => @stylesheet
        )
      }
    end
  end

  def edit
    find_constitution
    case @organisation
    when Coop
      @allow_editing = true
      @constitution_wrapper = ConstitutionWrapper.new(:constitution => @constitution)
    end
  end

  def update
    find_constitution
    @constitution_wrapper = ConstitutionWrapper.new(:constitution => @constitution)
    if @constitution_wrapper.update_attributes(params[:constitution])
      redirect_to(admin_coop_path(@organisation), :notice => "Rule changes were made")
    else
      @allow_editing = true # We have already authorized that the user can update a Constitution
      render(:action => :edit)
    end
  end

private

  def find_constitution
    @organisation = Organisation.find(params[:id])
    @constitution = @organisation.constitution
  end
end
