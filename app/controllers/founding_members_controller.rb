class FoundingMembersController < ApplicationController
  def new
    authorize! :create, FoundingMember
    
    @founding_member = co.build_founding_member
  end
  
  def create
    authorize! :create, FoundingMember
    
    @founding_member = co.build_founding_member(params[:founding_member])
    @founding_member.send_welcome = true
    if @founding_member.save
      track_analytics_event('InvitesFoundingMember')
      flash[:notice] = "Added a new founding member"
      redirect_to members_path
    else
      flash[:error] = "There was a problem with the new member's details"
      render :action => :new
    end
  end
end
