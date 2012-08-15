class MembershipApplicationFormsController < ApplicationController
  def edit
    authorize! :update, co
  end

  def update
    authorize! :update, co

    co.membership_application_text = params[:organisation][:membership_application_text]
    co.save!
    flash[:notice] = "The membership application form has been amended."

    redirect_to members_path
  end
end
