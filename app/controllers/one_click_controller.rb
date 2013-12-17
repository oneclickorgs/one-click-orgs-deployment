class OneClickController < ApplicationController
  before_filter :current_organisation
  
  def index
    redirect_to(:action => 'dashboard')
  end
  
  def constitution
    @page_title = "Constitution"
    prepare_constitution_view
    
    respond_to do |format|
      format.html
      format.pdf {
        generate_pdf(@page_title)
      }
    end  
  end
  
  def dashboard
    # only_provides :html
    
    if current_organisation.pending? || current_organisation.proposed?
      redirect_to(:action => 'constitution')
      return
    end
            
    # Fetch open proposals
    @proposals = co.proposals.currently_open
    
    @new_proposal = co.proposals.new
    @new_member = co.members.new
    @new_member.member_class = co.default_member_class
    
    @timeline = [
      co.members.all,
      co.proposals.all,
      co.decisions.all,
      co.resignations.all
    ].flatten.map(&:to_event).compact.sort{|a, b| b[:timestamp] <=> a[:timestamp]}
  end
  
  def amendments
    @page_title = "Amendments"
    prepare_constitution_view
    
    @allow_editing = current_user.has_permission(:constitution_proposal) &&
      !current_organisation.proposed?
  end
  
end
