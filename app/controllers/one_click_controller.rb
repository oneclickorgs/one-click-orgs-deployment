class OneClickController < ApplicationController
  before_filter :current_organisation
  
  def index
    redirect_to(:action => 'dashboard')
  end
  
  def dashboard
    # only_provides :html
    
    if current_organisation.pending? || current_organisation.proposed?
      redirect_to constitution_path
      return
    end
            
    # Fetch open proposals
    @proposals = co.proposals.currently_open
    
    @new_proposal = co.proposals.new
    @add_member_proposal = co.add_member_proposals.build
    
    @timeline = [
      co.members.all,
      co.proposals.all,
      co.decisions.all
    ].flatten.map(&:to_event).compact.sort{|a, b| b[:timestamp] <=> a[:timestamp]}
  end
  
  def amendments
    @page_title = "Amendments"
    find_constitution
    
    @allow_editing = current_user.has_permission(:constitution_proposal) &&
      !current_organisation.proposed?
  end
  
end
