class Admin::ConstitutionsController < AdminController
  def show
    # TODO Fix duplication between this and ::ConstitutionsController#show

    @organisation = Organisation.find(params[:id])
    @constitution = @organisation.constitution

    case @organisation
    when Coop
      @page_title = "Rules"
      @header_left = "Co-operatives UK Multi-stakeholder Co-operative Model Rules (One-Click Model)"
      @header_right = nil
      @stylesheet = File.join(Rails.root, 'app', 'assets', 'stylesheets', 'coop_rules_pdf.css')
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
end
