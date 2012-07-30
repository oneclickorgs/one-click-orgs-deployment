class BoardMeetingsController < ApplicationController
  def new
    @board_meeting = co.board_meetings.build
  end

  def create
    @board_meeting = co.board_meetings.build(params[:board_meeting])
    @board_meeting.creator = current_user
    @board_meeting.save!
    redirect_to meetings_path
  end
end
