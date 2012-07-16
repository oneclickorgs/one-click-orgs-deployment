class ResolutionProposalsController < ApplicationController
  def new
    @resolution_proposal = co.resolution_proposals.build
  end
  
  def create
    @resolution_proposal = co.resolution_proposals.build(params[:resolution_proposal])
    @resolution_proposal.proposer = current_user
    @resolution_proposal.save!
    redirect_to proposals_path
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
end
