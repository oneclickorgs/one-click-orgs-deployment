class ProposalsController < ApplicationController
  respond_to :html
  
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
    authorize! :create, Proposal
    
    @proposal = co.proposals.new(params[:proposal])
    @proposal[:type] = 'Proposal' # Bug #138, cf. http://www.simple10.com/rails-3-sti/
    @proposal.proposer_member_id = current_user.id #fixme
        
    if @proposal.save
      redirect_to proposal_path(@proposal), :flash => {:notice => "Proposal was successfully created"}
    else
      # TODO Preserve entered form values; render instead of redirect;
      # use error_messages_for.
      redirect root_path, :flash => {:error => "Proposal not created"}
    end
  end
end # Proposals
