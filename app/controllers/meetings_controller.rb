class MeetingsController < ApplicationController
  def show
    @meeting = co.meetings.find(params[:id])
    
    @comments = @meeting.comments
    @comment = Comment.new
  end
  
  def create
    @meeting = co.meetings.build(params[:meeting])
    @meeting.save
    redirect_to root_path
  end
end
