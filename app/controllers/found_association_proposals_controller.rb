class FoundAssociationProposalsController < ApplicationController
  def new
    authorize! :create, FoundAssociationProposal
  end

  def create
    authorize! :create, FoundAssociationProposal
    
    found_association_proposal_parameters = params[:found_association_proposal] || {}
    found_association_proposal = co.found_association_proposals.build(found_association_proposal_parameters)
    found_association_proposal.proposer = current_user
    
    if found_association_proposal.save
      co.propose!
      track_analytics_event('StartsFoundingVote')
      redirect_to(root_path, :notice => "The founding vote has now begun.")
    else
      # TODO Render instead of redirect; use error_messages_for.
      redirect_to(constitution_path, :flash => {:error => "Error creating proposal: #{proposal.errors.inspect}"})
    end
  end
end
