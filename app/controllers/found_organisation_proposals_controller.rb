class FoundOrganisationProposalsController < ApplicationController
  before_filter :require_found_organisation_permission
  
  def new
  end

  def create
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

private

  def require_found_organisation_permission
    if !current_user.has_permission(:found_organisation_proposal)
      flash[:error] = "You do not have sufficient permissions to create such a proposal!"
      redirect_back_or_default
    end
  end
end
