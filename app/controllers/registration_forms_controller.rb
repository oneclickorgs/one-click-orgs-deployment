require 'pdf_form_filler'
require 'yaml'

class RegistrationFormsController < ApplicationController
  def show
    respond_to do |format|
      format.pdf do
        pdf = RegistrationForm.new(co).to_pdf

        send_data(pdf, :filename => "#{co.name} Registration Form.pdf",
          :type => 'application/pdf', :disposition => 'attachment')
      end
    end
  end

  def edit
    @registration_form = co

    @members = co.members
  end

  def update
    @registration_form = co

    @registration_form.reg_form_timing_factors = params[:registration_form][:reg_form_timing_factors]
    @registration_form.reg_form_financial_year_end = params[:registration_form][:reg_form_financial_year_end]
    @registration_form.reg_form_close_links = params[:registration_form][:reg_form_close_links]
    @registration_form.reg_form_signatories_attributes = params[:registration_form][:reg_form_signatories_attributes]

    if @registration_form.save
      flash[:notice] = "Your changes to the Registration Form were saved."
    else
      flash[:error] = "There was a problem saving your changes to the Registration Form: #{@registration_form.errors.full_messages.to_sentence}"
    end
    redirect_to edit_registration_form_path
  end
end
