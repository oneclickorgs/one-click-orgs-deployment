class EjectMemberProposalsController < ApplicationController
  def create
    authorize! :create, EjectMemberProposal
    
    @eject_member_proposal = co.eject_member_proposals.build(params[:eject_member_proposal])
    @eject_member_proposal.proposer = current_user
    if @eject_member_proposal.save
      flash[:notice] = "Ejection proposal successfully created"
      redirect_to root_path
    else
      flash.now[:error] = "Error creating proposal: #{@eject_member_proposal.errors.inspect}"
      render :action => :new
    end
    
    # TODO Push direct edit into appropriate resource controller
    # @member = co.members.find(params[:id])
    # 
    # title = "Eject #{@member.name} from #{current_organisation.name}"
    # proposal = co.eject_member_proposals.new(
    #   :title => title,
    #   :description => params[:description],
    #   :proposer_member_id => current_user.id,
    #   :parameters => {'id' => @member.id}
    # )
    # 
    # if proposal.start
    #   if proposal.accepted?
    #     redirect_to(members_path, :notice => "Member successfully ejected")
    #   else
    #     redirect_to(root_path, :notice => "Ejection proposal successfully created")
    #   end
    # else
    #   redirect member_path(@member), :flash => {:error => "Error creating proposal: #{proposal.errors.inspect}"}
    # end
  end
end
