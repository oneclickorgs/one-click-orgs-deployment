class ConstitutionProposalBundlesController < ApplicationController
  def create
    authorize! :create, ConstitutionProposalBundle

    @constitution_proposal_bundle = co.build_constitution_proposal_bundle(
      params[:constitution_proposal_bundle]
    )
    @constitution_proposal_bundle.proposer = current_user

    if @constitution_proposal_bundle.save
      case co
      when Coop
        redirect_to(proposals_path, :notice => "Draft resolutions successfully created")
      else
        redirect_to(root_path, :notice => "Constitutional amendment proposals successfully created")
      end
    else
      flash.now[:error] = "There was a problem with your amendments"
      render(:action => 'TODO What action?')
    end
  end
end
