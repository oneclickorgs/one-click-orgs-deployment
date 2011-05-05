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
      flash[:error] = "Error creating proposal: #{proposal.errors.inspect}"
      redirect_back_or_default(member_path(@member))
    end
    
    # @member = co.members.find(params[:id])
    # @new_member_class = co.member_classes.find(params[:member][:member_class_id])
    # 
    # title = "Change member class of #{@member.name} from #{@member.member_class.name} to #{@new_member_class.name}"
    # proposal = co.change_member_class_proposals.new(
    #   :title => title,
    #   :proposer_member_id => current_user.id,
    #   :description => params[:description],
    #   :parameters => ChangeMemberClassProposal.serialize_parameters(
    #     'id' => @member.id, 
    #     'member_class_id' => @new_member_class.id)
    # )
    # 
    # if proposal.start
    #   if proposal.accepted?
    #     flash[:notice] = "Membership class successfully changed"
    #   else
    #     flash[:notice] = "Membership class proposal successfully created"
    #   end
    #   redirect_back_or_default(member_path(@member))
    # else
    #   flash[:error] = "Error creating proposal: #{proposal.errors.inspect}"
    #   redirect_back_or_default(member_path(@member))
    # end
  end
end
