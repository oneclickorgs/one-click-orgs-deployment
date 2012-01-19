class MeetingsController < ApplicationController
  def show
    @meeting = co.meetings.find(params[:id])
    
    unless can?(:read, @meeting)
      redirect_to root_path
      return
    end
    
    @comments = @meeting.comments
    @comment = Comment.new
  end
  
  def create
    # A Meeting must know its organisation before we
    # try to set its participants.
    @meeting = co.meetings.build
    @meeting.attributes = params[:meeting]
    
    @meeting.creator = current_user
    
    if @meeting.save
      redirect_to root_path
    else
      flash[:error] = "There was a problem saving the minutes."
      
      @directors = co.members.where(:member_class_id => co.member_classes.find_by_name('Director').id)
      
      render :action => 'new'
    end
  end
end
