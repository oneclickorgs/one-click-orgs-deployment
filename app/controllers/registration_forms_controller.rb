class RegistrationFormsController < ApplicationController
  def edit
    @registration_form = co
  end

  def update
    @registration_form = co

    @registration_form.reg_form_timing_factors = params[:registration_form][:reg_form_timing_factors]
    @registration_form.reg_form_financial_year_end = params[:registration_form][:reg_form_financial_year_end]
    @registration_form.reg_form_membership_required = case params[:registration_form][:reg_form_membership_required]
    when 'true'
      true
    when 'false'
      false
    else
      nil
    end

    if @registration_form.save
      flash[:notice] = "Your changes to the Registration Form were saved."
    else
      flash[:error] = "There was a problem saving your changes to the Registration Form: #{@registration_form.errors.full_messages.to_sentence}"
    end
    redirect_to edit_registration_form_path
  end
end
