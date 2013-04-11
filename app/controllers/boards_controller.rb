class BoardsController < ApplicationController
  def show
    @upcoming_meetings = co.board_meetings.upcoming
    @past_meetings = co.board_meetings.past
    @proposals = co.board_resolutions.currently_open
    @draft_proposals = current_user.board_resolutions.draft
  end
end
