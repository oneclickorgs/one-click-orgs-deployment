class MembersController < ApplicationController
  def index
    case co
    when Association
      @page_title = "Members"
      @members = co.members.active
      @pending_members = co.members.pending
      if can?(:create, FoundingMember)
        @founding_member = co.build_founding_member
      end
    end
    
    respond_to do |format|
      format.html
      format.pdf {
        generate_pdf(@page_title)
      }
      format.csv {
        generate_csv
      }
    end
  end

  def show
    @member = co.members.find(params[:id])
    @member_presenter = MemberPresenter.new(@member)
    case co
    when Association
      @eject_member_proposal = co.eject_member_proposals.build(:member_id => @member.id)
      @page_title = "Member profile"
    end
  end

  def edit
    @member = co.members.find(params[:id])
    authorize! :update, @member
    @page_title = "Edit your account"
  end
  
  def update
    id, member = params[:id], params[:member]
    @member = co.members.find(id)
    authorize! :update, Member
    if @member.update_attributes(member)
       redirect_to member_path(@member), :notice => "Account updated."
    else
      flash.now[:error] = "There was a problem with your new details."
      render(:action => :edit)
    end
  end

private
  
  # Create csv file of members in an org, then send data 
  # as a file stream for downloads.
  #
  # @see http://api.rubyonrails.org/classes/ActionController/Streaming.html#method-i-send_data
  def generate_csv
    case co
    when Association
      # Only Associations use the 'inducted_at' field.
      fields = [:first_name, :last_name, :email, :inducted_at, :last_logged_in_at]
    end
    
    csv = FasterCSV.generate do |csv|
      csv << fields
      @members.each do |member|
        csv << fields.collect { |f| member.send(f) }
      end
    end
    
    filename = case co
    when Association
      "#{co.name} Members.csv"
    end
    
    send_data(csv,
      :filename => filename,
      :type => 'text/csv',
      :disposition => 'attachment'
    )
  end
end
