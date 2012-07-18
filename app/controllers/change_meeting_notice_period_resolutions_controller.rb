class ChangeMeetingNoticePeriodResolutionsController < ApplicationController
  def new
    @change_meeting_notice_period_resolution = co.change_meeting_notice_period_resolutions.build
  end

  def create
    @change_meeting_notice_period_resolution = co.change_meeting_notice_period_resolutions.build(params[:change_meeting_notice_period_resolution])
    
    @change_meeting_notice_period_resolution.proposer = current_user
    @change_meeting_notice_period_resolution.draft = true

    @change_meeting_notice_period_resolution.save!

    if @change_meeting_notice_period_resolution.accepted?
      flash[:notice] = "The notice period for General Meetings has been changed."
    else
      if @change_meeting_notice_period_resolution.notice_period_increased?
        flash[:notice] = "A draft resolution to increase the General Meeting notice period has been created."
      else
        flash[:notice] = "A draft resolution to decrease the General Meeting notice period has been created."
      end
    end

    redirect_to meetings_path
  end
end
