class MembersController < ApplicationController

  respond_to :html
  
  before_filter :require_membership_proposal_permission, :only => [:update]
  before_filter :require_direct_edit_permission, :only => [:create_founding_member]

  def index
    @page_title = "Members"
    @current_organisation = co
    @members = co.members.active
    @pending_members = co.members.pending
    @new_member = co.members.new
    
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
  
  def create_founding_member
    member_attributes = params[:member]
    member_attributes[:member_class_id] = co.member_classes.find_by_name('Founding Member').id.to_s
    member_attributes[:send_welcome] = true
    
    @member = co.members.build(member_attributes)
    
    if @member.save
      redirect_to members_path, :notice => "Added a new founding member."
    else
      flash[:error] = "There was a problem with the new member's details: #{@member.errors.full_messages.to_sentence}"
      render :action => :new
    end
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
  
private

  def require_direct_edit_permission
    if !current_user.has_permission(:direct_edit)
      flash[:error] = "You do not have sufficient permissions to make changes!"
      redirect_back_or_default
    end
  end
end # Members
