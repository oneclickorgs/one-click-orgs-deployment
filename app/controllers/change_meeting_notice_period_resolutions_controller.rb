class ChangeMeetingNoticePeriodResolutionsController < ApplicationController
  def new
    @change_meeting_notice_period_resolution = co.change_meeting_notice_period_resolutions.build
  end

  def create
    @change_meeting_notice_period_resolution = co.change_meeting_notice_period_resolutions.build(params[:change_meeting_notice_period_resolution])
    @change_meeting_notice_period_resolution.proposer = current_user
    @change_meeting_notice_period_resolution.save!
    redirect_to meetings_path
  end
end
