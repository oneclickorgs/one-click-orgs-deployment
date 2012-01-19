require 'lib/not_found'

class MembersController < ApplicationController

  respond_to :html
  
  before_filter :require_membership_proposal_permission, :only => [:new, :create, :update, :destroy, :change_class]
  before_filter :require_direct_edit_permission, :only => [:create_founding_member]

  def index
    @page_title = "Members"
    @current_organisation = co
    @members = co.members.active
    @pending_members = co.members.pending
    @new_member = co.members.new
    
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
    raise NotFound unless @member
    
    @timeline = [
      @member,
      @member.proposals.all,
      @member.votes.all
    ].flatten.map(&:to_event).compact.sort{|a, b| b[:timestamp] <=> a[:timestamp]}
    
    @page_title = "Member profile"
    
    respond_with @member
  end

  def new
    # only_provides :html
    @member = co.members.new
    respond_with @member
  end

  def edit
    # only_provides :html
    @member = co.members.find(params[:id])
    unless current_user.id == params[:id].to_i
      flash[:error] = "You are not authorized to do this."
      redirect_back_or_default
      return
    end
    @page_title = "Edit your account"
    respond_with @member
  end

  def create
    member = params[:member]
    title = "Add #{member['first_name']} #{member['last_name']} as a member of #{current_organisation.name}" # TODO: should default in model
    proposal = co.add_member_proposals.new(
      :title => title,
      :proposer_member_id => current_user.id,
      :parameters => member
    )
    
    if proposal.start
      if proposal.accepted?
        redirect_to members_path, :notice => "New member successfully created"
      else
        redirect_to members_path, :notice => "Add Member Proposal successfully created"
      end
    else
      @member = proposal.draft_member
      flash[:error] = "Error creating proposal: #{proposal.errors.full_messages.to_sentence}"
      render :action => :new
    end
  end
  
  def create_founding_member
    member_attributes = params[:member]
    member_attributes[:member_class_id] = co.member_classes.find_by_name('Founding Member').id.to_s
    member_attributes[:send_welcome] = true
    
    @member = co.members.build(member_attributes)
    
    if @member.save
      track_analytics_event('InvitesFoundingMember')
      redirect_to members_path, :notice => "Added a new founding member."
    else
      flash[:error] = "There was a problem with the new member's details: #{@member.errors.full_messages.to_sentence}"
      render :action => :new
    end
  end

  def update
    id, member = params[:id], params[:member]
    @member = co.members.find(id)
    if @member.update_attributes(member)
       redirect_to member_path(@member), :notice => "Account updated."
    else
      flash.now[:error] = "There was a problem with your new details."
      render(:action => :edit)
    end
  end

  def confirm_resign
    @page_title = "Are you sure you want to resign from this organisation?"
    @member = current_user
    respond_with @member
  end
  
  def resign
    @member = current_user
    @member.resign!
    redirect_to(resigned_members_path)
  end
  
  def resigned
    reset_session
  end

  def destroy
    @member = co.members.find(params[:id])
    
    title = "Eject #{@member.name} from #{current_organisation.name}"
    proposal = co.eject_member_proposals.new(
      :title => title,
      :description => params[:description],
      :proposer_member_id => current_user.id,
      :parameters => {'id' => @member.id}
    )
    
    if proposal.start
      if proposal.accepted?
        redirect_to(members_path, :notice => "Member successfully ejected")
      else
        redirect_to(root_path, :notice => "Ejection proposal successfully created")
      end
    else
      redirect member_path(@member), :flash => {:error => "Error creating proposal: #{proposal.errors.inspect}"}
    end
  end
  
  def change_class
    @member = co.members.find(params[:id])
    @new_member_class = co.member_classes.find(params[:member][:member_class_id])
    
    title = "Change member class of #{@member.name} from #{@member.member_class.name} to #{@new_member_class.name}"
    proposal = co.change_member_class_proposals.new(
      :title => title,
      :proposer_member_id => current_user.id,
      :description => params[:description],
      :parameters => ChangeMemberClassProposal.serialize_parameters(
        'id' => @member.id, 
        'member_class_id' => @new_member_class.id)
    )
    
    if proposal.start
      if proposal.accepted?
        flash[:notice] = "Membership class successfully changed"
      else
        flash[:notice] = "Membership class proposal successfully created"
      end
      redirect_back_or_default(member_path(@member))
    else
      flash[:error] = "Error creating proposal: #{proposal.errors.inspect}"
      redirect_back_or_default(member_path(@member))
    end
  end

private

  def require_direct_edit_permission
    if !current_user.has_permission(:direct_edit)
      flash[:error] = "You do not have sufficient permissions to make changes!"
      redirect_back_or_default
    end
  end

  def require_membership_proposal_permission
    if !current_user.has_permission(:membership_proposal)
      flash[:error] = "You do not have sufficient permissions to create such a proposal!"
      redirect_back_or_default
    end
  end
  
  # Create csv file of members in an org, then send data 
  # as a file stream for downloads.
  #
  # @see http://api.rubyonrails.org/classes/ActionController/Streaming.html#method-i-send_data
  def generate_csv
    fields = [:first_name, :last_name, :email, :inducted_at, :last_logged_in_at]
    
    # In Ruby 1.9, FasterCSV is provided as the stdlib's CSV library.
    csv_library = defined?(FasterCSV) ? FasterCSV : CSV
    
    csv = csv_library.generate do |csv|
      csv << fields
      @members.each do |member|
        csv << fields.collect { |f| member.send(f) }
      end
    end
    send_data(csv, :filename => "#{co.name} Members.csv",
      :type => 'text/csv', :disposition => 'attachment')
  end

end # Members
