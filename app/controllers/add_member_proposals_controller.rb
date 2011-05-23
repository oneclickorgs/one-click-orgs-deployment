class AddMemberProposalsController < ApplicationController
  def new
    authorize! :create, AddMemberProposal
    
    @add_member_proposal = co.add_member_proposals.build
  end
  
  def create
    authorize! :create, AddMemberProposal
    
    @add_member_proposal = co.add_member_proposals.build(params[:add_member_proposal])
    @add_member_proposal.proposer = current_user
    if @add_member_proposal.save
      flash[:notice] = "Add Member Proposal successfully created"
      redirect_to root_path
    else
      # TODO use error_message_for in view instead of cramming errors messages into the flash
      flash.now[:error] = "Error creating proposal: #{@add_member_proposal.errors.full_messages.to_sentence}"
      render :action => :new
    end
  end
end
