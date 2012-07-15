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
end
