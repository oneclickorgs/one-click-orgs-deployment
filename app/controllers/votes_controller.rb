class VotesController < ApplicationController
  #FIXME duplication  
  def vote_for
    authorize! :create, Vote
    
    id, return_to = params[:id], params[:return_to]
    raise ArgumentError, "need proposal id" unless id
    
    proposal = co.proposals.find(params[:id])
    
    begin
      current_user.cast_vote(:for, proposal)
      redirect_to return_to, :notice => "Vote for proposal cast"
    rescue Exception => e
      redirect_to return_to, :notice => "Error casting vote: #{e}"
    end
  end
  
  #FIXME duplication
  def vote_against
    authorize! :create, Vote
    
    id, return_to = params[:id], params[:return_to]
    raise ArgumentError, "need proposal id" unless id    
    
    proposal = co.proposals.find(params[:id])
        
    begin
      current_user.cast_vote(:against, proposal)
      redirect_to return_to, :notice => "Vote against proposal cast"
    rescue Exception => e
      # TODO better error message
      redirect_to return_to, :notice => "Error casting vote: #{e}"
    end
  end
end
