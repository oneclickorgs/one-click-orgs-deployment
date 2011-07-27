class CommentsController < ApplicationController
  def create
    @commentable = if params[:proposal_id]
      co.proposals.find(params[:proposal_id])
    elsif params[:meeting_id]
      co.meetings.find(params[:meeting_id])
    end
    
    redirect :back unless @commentable
    
    @comment = @commentable.comments.build(params[:comment])
    @comment.author = current_user
    if @comment.save
      redirect_to(@commentable, :notice => "Comment added.")
    else
      # TODO Use render instead of redirect; use error_messages_for.
      redirect_to(@commentable, :error => "There was a problem saving your comment.")
    end
  end
end
