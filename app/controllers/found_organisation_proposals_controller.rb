class FoundOrganisationProposalsController < ApplicationController
  def new
    authorize! :create, FoundOrganisationProposal
  end

  def create
    authorize! :create, FoundOrganisationProposal
    
    found_organisation_proposal_parameters = params[:found_organisation_proposal] || {}
    found_organisation_proposal_parameters[:proposer] = current_user
    
    found_organisation_proposal = co.found_organisation_proposals.build(found_organisation_proposal_parameters)
    
    if found_organisation_proposal.save
      co.proposed!
      redirect_to(root_path, :notice => "The founding vote has now begun.")
    else
      redirect_to(constitution_path, :flash => {:error => "Error creating proposal: #{proposal.errors.inspect}"})
    end
  end
end
