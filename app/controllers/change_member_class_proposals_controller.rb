class ChangeMemberClassProposalsController < ApplicationController
  def create
    authorize! :create, ChangeMemberClassProposal
    
    # TODO Make this work
    @change_member_class_proposal = co.change_member_class_proposals.build(params[:change_member_class_proposal])
    @change_member_class_proposal.proposer = current_user
    if @change_member_class_proposal.save
      flash[:notice] = "Membership class proposal successfully created"
      redirect_to(member_path(@change_member_class_proposal.member))
    else
      # TODO Use a render instead of redirect, so we can preserve the entered
      # form details, and use error_messages_for to present errors better.
      flash[:error] = "Error creating proposal: #{proposal.errors.inspect}"
      redirect_back_or_default(member_path(@member))
    end
  end
end
