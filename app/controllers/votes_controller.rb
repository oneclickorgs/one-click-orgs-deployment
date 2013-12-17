require 'uri'

class VotesController < ApplicationController

  before_filter :require_vote_permission, :only => [:vote_for, :vote_against]

  #FIXME duplication  
  def vote_for
    id, return_to = params[:id], params[:return_to]
    raise ArgumentError, "need proposal id" unless id

    proposal = co.proposals.find(id)

    return_to = sanitise_path(return_to)
    
    begin
      current_user.cast_vote(:for, proposal)
      
      if proposal && proposal.is_a?(FoundOrganisationProposal)
        if current_user.member_class.name == "Founder"
          track_analytics_event("FounderSupportsFounding")
        end
      end
      
      redirect_to return_to, :notice => "Vote for proposal cast"
    rescue Exception => e
      redirect_to return_to, :notice => "Error casting vote: #{e}"
    end
  end
  
  #FIXME duplication
  def vote_against
    id, return_to = params[:id], params[:return_to]
    raise ArgumentError, "need proposal id" unless id

    proposal = co.proposals.find(id)
    
    return_to = sanitise_path(return_to)
    
    begin
      current_user.cast_vote(:against, proposal)
      redirect_to return_to, :notice => "Vote against proposal cast"
    rescue Exception => e
      redirect_to return_to, :notice => "Error casting vote: #{e}"
    end    
  end

private

  def require_vote_permission
    if !current_user.has_permission(:vote)
      flash[:error] = "You do not have sufficient permissions to vote!"
      redirect_back_or_default
    end
  end
  
  # If the given path is not in fact a path, but is a full URL, then
  # replace it with a path to our site root.
  # 
  # This is to avoid a vulnerability where an attacker crafts a URL
  # which causes our application to redirect to an external site
  # chosen by the attacker.
  def sanitise_path(path)
    if URI.parse(path).host
      root_path
    else
      path
    end
  end
  
end
