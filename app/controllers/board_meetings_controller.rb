class BoardMeetingsController < ApplicationController
  def show
    @board_meeting = co.board_meetings.find(params[:id])
  end

  def new
    @board_meeting = co.board_meetings.build
  end

  def create
    @board_meeting = co.board_meetings.build(params[:board_meeting])
    @board_meeting.creator = current_user
    @board_meeting.save!
    redirect_to board_path
  end

  def edit
    @board_meeting = co.board_meetings.find(params[:id])
    @directors = co.directors
  end

  def update
    @board_meeting = co.board_meetings.find(params[:id])
    @board_meeting.update_attributes(params[:board_meeting])
    redirect_to board_path
  end
end
