class CommentsController < ApplicationController
  def create
    @commentable = if params[:proposal_id]
      co.proposals.find(params[:proposal_id])
    elsif params[:meeting_id]
      co.meetings.find(params[:meeting_id])
    elsif params[:resolution_id]
      co.resolutions.find(params[:resolution_id])
    elsif params[:resolution_proposal_id]
      co.resolution_proposals.find(params[:resolution_proposal_id])
    end
    
    unless @commentable
      redirect_to :back
      return
    end

    @comment = @commentable.comments.build(params[:comment])
    @comment.author = current_user
    
    commentable_path = case @commentable
    when Resolution
      resolution_path(@commentable)
    when ResolutionProposal
      resolution_proposal_path(@commentable)
    when Proposal
      proposal_path(@commentable)
    else
      url_for(@commentable)
    end
    
    if @comment.save
      redirect_to(commentable_path, :notice => "Comment added.")
    else
      # TODO Use render instead of redirect; use error_messages_for.
      redirect_to(commentable_path, :error => "There was a problem saving your comment.")
    end
  end
end
