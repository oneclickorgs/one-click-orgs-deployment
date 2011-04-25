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
        # If wkhtmltopdf is working...
        begin
          html = render_to_string(:layout => false , :action => "constitution.pdf.haml")
        
          # Call PDFKit with any wkhtmltopdf --extended-help options
          kit = PDFKit.new(html, :page_size => 'A4', :header_right => 'Printed on [date]')
        
          # Add our CSS file
          kit.stylesheets << "#{Rails.root}/public/stylesheets/pdf.css"

          send_data(kit.to_pdf, :filename => "#{@organisation_name} Constitution.pdf",
            :type => 'application/pdf', :disposition => 'inline')
            # disposition can be set to `attachment` to force a download
          
          return
        
        # Fail if it's not installed
        rescue
          redirect_to(:action => 'constitution')
        
        end
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
    @new_member = co.members.new(:member_class => co.default_member_class)
    
    @timeline = [
      co.members.all,
      co.proposals.all,
      co.decisions.all
    ].flatten.map(&:to_event).compact.sort{|a, b| b[:timestamp] <=> a[:timestamp]}
  end
  
  def amendments
    @page_title = "Amendments"
    prepare_constitution_view
    
    @allow_editing = current_user.has_permission(:constitution_proposal) &&
      !current_organisation.proposed?
  end
  
end
