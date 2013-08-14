class Admin::RegistrationFormsController < AdminController
  def show
    @organisation = Organisation.find(params[:id])

    respond_to do |format|
      format.pdf do
        pdf = RegistrationForm.new(@organisation).to_pdf

        send_data(pdf, :filename => "#{@organisation.name} Registration Form.pdf",
          :type => 'application/pdf', :disposition => 'attachment')
      end
    end
  end

  def edit
    @organisation = Organisation.find(params[:id])
    @registration_form = @organisation
    @members = @organisation.members_with_signatories_selected
  end

  def update
    @organisation = Organisation.find(params[:id])
    @organisation.attributes = params[:registration_form]
    @organisation.save
    redirect_to(admin_coop_path(@organisation))
  end
end
