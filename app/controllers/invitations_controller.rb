class InvitationsController < ApplicationController
  skip_before_filter :ensure_authenticated
  skip_before_filter :prepare_notifications

  def edit
    # TODO should be searching scoped by organisation.
    @invitation = Invitation.find_by_id(params[:id])

    unless @invitation
      redirect_to(root_path)
      return
    end

    @show_founding_warnings = @invitation.show_founding_warnings?
  end

  def update
    # TODO should be searching scoped by organisation
    @invitation = Invitation.find(params[:id])
    unless @invitation
      redirect_to(root_path)
      return
    end

    if @invitation.update_attributes(params[:invitation])
      log_in @invitation.member

      flash[:notice] = "Your new password has been saved."
      redirect_to root_path
    else
      flash.now[:error] = "There was a problem with your new details."
      render :action => :edit
    end
  end
end
