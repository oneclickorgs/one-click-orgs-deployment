class EjectMemberProposalsController < ApplicationController
  def create
    authorize! :create, EjectMemberProposal
    
    @eject_member_proposal = co.eject_member_proposals.build(params[:eject_member_proposal])
    @eject_member_proposal.proposer = current_user
    if @eject_member_proposal.save
      flash[:notice] = "Ejection proposal successfully created"
      redirect_to root_path
    else
      flash.now[:error] = "Error creating proposal"
      render :action => :new
    end
  end
end
