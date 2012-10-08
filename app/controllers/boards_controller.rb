class BoardsController < ApplicationController
  def show
    @upcoming_meetings = co.board_meetings.upcoming
  end
end
