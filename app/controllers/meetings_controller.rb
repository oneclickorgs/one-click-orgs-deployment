class MeetingsController < ApplicationController
  def show
    @meeting = co.meetings.find(params[:id])
    
    @comments = @meeting.comments
    @comment = Comment.new
  end
  
  def create
    # A Meeting must know its organisation before we
    # try to set its participants.
    @meeting = co.meetings.build
    @meeting.attributes = params[:meeting]
    @meeting.save
    redirect_to root_path
  end
end
