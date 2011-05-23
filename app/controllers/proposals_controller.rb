class ProposalsController < ApplicationController
  respond_to :html
  
  before_filter :require_freeform_proposal_permission, :only => [:create]
  
  def index
    # Fetch open proposals
    @proposals = co.proposals.currently_open
    
    # Fetch five most recent decisions
    @decisions = co.decisions.order("id DESC").limit(5)
    
    # Fetch five most recent failed proposals
    @failed_proposals = co.proposals.failed.limit(5)
  end

  def show
    @proposal = co.proposals.find(params[:id])
    @comments = @proposal.comments
    @comment = Comment.new
    @page_title = "Proposal"
    respond_with @proposal
  end

  # Freeform proposal
  def create
    @proposal = co.proposals.new(params[:proposal])
    @proposal[:type] = 'Proposal' # Bug #138, cf. http://www.simple10.com/rails-3-sti/
    @proposal.proposer_member_id = current_user.id #fixme
        
    if @proposal.start
      # Freeform proposal has no need for direct enactment logic during pending stage.
      redirect_to proposal_path(@proposal), :flash => {:notice => "Proposal was successfully created"}
    else
      redirect root_path, :flash => {:error => "Proposal not created"}
    end
  end
  
private

  def require_freeform_proposal_permission
    if !current_user.has_permission(:freeform_proposal)
      flash[:error] = "You do not have sufficient permissions to create such a proposal!"
      redirect_back_or_default
    end
  end
end # Proposals
