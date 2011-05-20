class FoundingMembersController < ApplicationController
  before_filter :require_direct_edit_permission, :only => [:new, :create]
  
  def new
    @founding_member = co.build_founding_member
  end
  
  def create
    @founding_member = co.build_founding_member(params[:founding_member])
    @founding_member.send_welcome = true
    if @founding_member.save
      flash[:notice] = "Added a new founding member"
      redirect_to members_path
    else
      flash[:error] = "There was a problem with the new member's details: #{@founding_member.errors.full_messages.to_sentence}"
      render :action => :new
    end
    
    # member_attributes = params[:member]
    # member_attributes[:member_class_id] = co.member_classes.find_by_name('Founding Member').id.to_s
    # member_attributes[:send_welcome] = true
    # 
    # @member = co.members.build(member_attributes)
    # 
    # if @member.save
    #   redirect_to members_path, :notice => "Added a new founding member."
    # else
    #   flash[:error] = "There was a problem with the new member's details: #{@member.errors.full_messages.to_sentence}"
    #   render :action => :new
    # end
  end
  
private
  
  def require_direct_edit_permission
    if !current_user.has_permission(:direct_edit)
      flash[:error] = "You do not have sufficient permissions to make changes!"
      redirect_back_or_default
    end
  end
end
