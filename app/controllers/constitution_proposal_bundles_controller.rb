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
        notice = if can?(:create, Resolution)
          "Draft resolutions successfully created"
        elsif can?(:create, ResolutionProposal)
          "Your suggestions have been sent"
        end
        redirect_to(proposals_path, :notice => notice)
      else
        redirect_to(root_path, :notice => "Constitutional amendment proposals successfully created")
      end
    else
      flash.now[:error] = "There was a problem with your amendments: #{@constitution_proposal_bundle.errors.full_messages.to_sentence}"
      edit_constitution_path
    end
  end
end
