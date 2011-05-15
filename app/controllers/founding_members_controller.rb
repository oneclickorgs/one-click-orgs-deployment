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
      flash[:notice] = "Added a new founding member"
      redirect_to members_path
    else
      flash[:error] = "There was a problem with the new member's details"
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
end
