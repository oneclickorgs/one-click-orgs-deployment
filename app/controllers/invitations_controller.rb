require 'lib/not_found'

class InvitationsController < ApplicationController
  skip_before_filter :ensure_authenticated
  skip_before_filter :prepare_notifications
  
  before_filter :set_up_organisation_name
  
  def edit
    @invitation_code = params[:id]
    @member = Member.find_by_invitation_code(@invitation_code)
    
    if @member
      # Require acceptance of terms and conditions.
      @member.terms_and_conditions = '0'
      
      # Show additional warnings if member is a founding member
      fop = co.found_organisation_proposals.last
      if fop && @member.created_at < fop.creation_date
        @show_founding_warnings = true
      end
    else
      # Invitation code expired, member probably already has an account.
      redirect_to(root_path)
    end
  end
  
  def update
    @invitation_code = params[:id]
    @member = Member.find_by_invitation_code(@invitation_code)
    
    unless @member
      redirect_to(root_path)
      return
    end
    
    @member.attributes = params[:member]
    if @member.save
      @member.clear_invitation_code!
      self.current_user = @member
      current_user.update_attribute(:last_logged_in_at, Time.now.utc)
      flash[:notice] = "Your new password has been saved."
      redirect_to(root_path)
    else
      flash.now[:error] = "There was a problem with your new details."
      render(:action => :edit)
    end
  end
  
private
  
  def set_up_organisation_name
    @organisation_name = co.name
  end
end

