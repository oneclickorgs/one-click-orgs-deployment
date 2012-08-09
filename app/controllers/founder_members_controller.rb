class FounderMembersController < ApplicationController
  def new
    authorize! :create, FounderMember

    @founder_member = co.build_founder_member
  end

  def create
    authorize! :create, FounderMember

    @founder_member = co.build_founder_member(params[:founder_member])
    @founder_member.send_welcome = true
    if @founder_member.save
      flash[:notice] = "Added a new founder member"
      redirect_to members_path
    else
      flash[:error] = "There was a problem with the new member's details"
      render :action => :new
    end
  end
end
