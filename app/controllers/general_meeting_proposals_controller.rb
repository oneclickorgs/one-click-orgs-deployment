class GeneralMeetingProposalsController < ApplicationController
  def show
    @general_meeting_proposal = co.general_meeting_proposals.find(params[:id])
  end

  def new
    @general_meeting_proposal = co.general_meeting_proposals.build
  end

  def create
    @general_meeting_proposal = co.general_meeting_proposals.build(params[:general_meeting_proposal])
    @general_meeting_proposal.proposer = current_user
    @general_meeting_proposal.save!
    redirect_to(general_meeting_proposal_path(@general_meeting_proposal))
  end
end
