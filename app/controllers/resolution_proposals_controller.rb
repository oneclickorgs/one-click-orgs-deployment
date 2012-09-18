class ResolutionProposalsController < ApplicationController
  def show
    @resolution_proposal = co.resolution_proposals.find(params[:id])
    @comments = @resolution_proposal.comments
    @comment = Comment.new
    @page_title = "Suggested resolution"
  end

  def new
    @resolution_proposal = co.resolution_proposals.build
  end
  
  def create
    @resolution_proposal = co.resolution_proposals.build(params[:resolution_proposal])
    @resolution_proposal.proposer = current_user
    @resolution_proposal.save!
    redirect_to resolution_proposal_path(@resolution_proposal)
  end

  def edit
    @resolution_proposal = co.resolution_proposals.find(params[:id])
  end

  def update
    @resolution_proposal = co.resolution_proposals.find(params[:id])
    @resolution_proposal.update_attributes(params[:resolution_proposal])
    redirect_to proposals_path
  end

  def pass
    @resolution_proposal = co.resolution_proposals.find(params[:id])
    @resolution_proposal.force_passed = true
    @resolution_proposal.close!
    redirect_to proposals_path
  end

  def pass_to_meeting
    @resolution_proposal = co.resolution_proposals.find(params[:id])
    @resolution_proposal.force_passed = true
    @resolution_proposal.create_draft_resolution = true
    @resolution_proposal.close!
    resolution = @resolution_proposal.new_resolution
    redirect_to new_general_meeting_path(:resolution_id => resolution)
  end
end
