class MembersController < ApplicationController
  def index
    @page_title = "Members"
    @members = co.members.active
    @pending_members = co.members.pending
    
    if can?(:create, FoundingMember)
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
    @member = co.members.find(params[:id])
    authorize! :update, @member
    @page_title = "Edit your account"
  end
  
  def update
    id, member = params[:id], params[:member]
    @member = co.members.find(id)
    authorize! :update, Member
    if @member.update_attributes(member)
       redirect_to member_path(@member), :notice => "Account updated."
    else
      flash.now[:error] = "There was a problem with your new details."
      render(:action => :edit)
    end
  end
end
