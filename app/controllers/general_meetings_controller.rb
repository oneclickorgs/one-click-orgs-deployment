class GeneralMeetingsController < ApplicationController
  def new
    @general_meeting = co.general_meetings.build

    if params[:resolution_id].present?
      @resolutions = [co.resolutions.find(params[:resolution_id])]
    end
  end

  def create
    @general_meeting = co.general_meetings.build(params[:general_meeting])
    @general_meeting.save!
    redirect_to meetings_path
  end
end
