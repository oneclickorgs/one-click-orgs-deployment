class GeneralMeetingsController < ApplicationController
  def new
    @general_meeting = co.general_meetings.build

    @draft_resolutions = co.resolutions.draft
    if params[:resolution_id].present?
      @draft_resolutions.find_by_id(params[:resolution_id]).try(:attached=, '1')
    end
  end

  def create
    @general_meeting = co.general_meetings.build(params[:general_meeting])
    @general_meeting.save!
    redirect_to meetings_path
  end
end
