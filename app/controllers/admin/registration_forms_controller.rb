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
end
