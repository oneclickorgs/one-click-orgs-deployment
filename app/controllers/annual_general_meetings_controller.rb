class AnnualGeneralMeetingsController < ApplicationController
  def new
    @annual_general_meeting = co.annual_general_meetings.build

    @draft_resolutions = co.resolutions.draft
    if params[:resolution_id].present?
      @draft_resolutions.find_by_id(params[:resolution_id]).try(:attached=, '1')
    end

    @directors_retiring = co.directors_retiring
  end

  def create
    @annual_general_meeting = co.annual_general_meetings.build(params[:annual_general_meeting])
    @annual_general_meeting.save!
    redirect_to meetings_path
  end

  def update
    @annual_general_meeting = co.annual_general_meetings.find(params[:id])
    @annual_general_meeting.update_attributes(params[:annual_general_meeting])
    redirect_to meetings_path
  end
end
