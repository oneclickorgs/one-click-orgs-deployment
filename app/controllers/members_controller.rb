class MembersController < ApplicationController

  respond_to :html
  
  before_filter :require_membership_proposal_permission, :only => [:update]

  def index
    @page_title = "Members"
    @current_organisation = co
    @members = co.members.active
    @pending_members = co.members.pending
    
    if co.pending? && current_user.has_permission(:membership_proposal)
      @founding_member = co.build_founding_member
    end
    
    respond_to do |format|
      format.html
      format.pdf {
        generate_pdf(@page_title)
      }
    end
  end

  def show
    @member = co.members.find(params[:id])
    @member_presenter = MemberPresenter.new(@member)
    @eject_member_proposal = co.eject_member_proposals.build(:member_id => @member.id)
    @page_title = "Member profile"
  end

  def edit
    # only_provides :html
    @member = co.members.find(params[:id])
    unless current_user.id == params[:id].to_i
      flash[:error] = "You are not authorized to do this."
      redirect_back_or_default
      return
    end
    @page_title = "Edit your account"
    respond_with @member
  end
  
  def update
    id, member = params[:id], params[:member]
    @member = co.members.find(id)
    if @member.update_attributes(member)
       redirect_to member_path(@member), :notice => "Account updated."
    else
      flash.now[:error] = "There was a problem with your new details."
      render(:action => :edit)
    end
  end
end # Members
