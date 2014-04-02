require 'csv'

class MembersController < ApplicationController

  skip_before_filter :ensure_authenticated, :ensure_member_active_or_pending, :only => [
    :new, :create, :created, :resigned
  ]


  def index
    case co
    when Association
      @page_title = "Members"
      @members = co.members.active
      @pending_members = co.members.pending
      if can?(:create, FoundingMember)
        @founding_member = co.build_founding_member
      end
    when Company
      @members = co.directors.active_and_pending

      @page_title = "Directors"
      @director = Director.new
    when Coop
      @page_title = "Members"
      @members = co.members.active
      if can?(:create, FounderMember)
        @founder_member = co.build_founder_member
        @pending_members = co.members.pending
      end
      @membership_issues = current_user.tasks.members_related.current

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

  def new
    @member = co.members.build
  end

  def create
    unless co.is_a?(Coop)
      redirect_to root_path
      return
    end

    @member = co.members.build(params[:member])
    @member.member_class = co.member_classes.find_by_name('Member')
    if @member.save
      redirect_to created_members_path
    else
      flash[:error] = "Sorry, there was a problem with your membership application."
      render(action: :new)
    end
  end

  def created
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
      flash[:notice] = "Account updated."
      case co
      when Association
        redirect_to member_path(@member)
      when Company
        redirect_to members_path
      when Coop
        redirect_to member_path(@member)
      end
    else
      flash.now[:error] = "There was a problem with your new details."
      render(:action => :edit)
    end
  end

  def confirm_resign
    @page_title = "Are you sure you want to resign from this organisation?"
    @member = current_user
  end

  def resign
    @member = current_user
    @member.resign!
    redirect_to(resigned_members_path)
  end

  def resigned
    reset_session
  end

  def induct
    @member = co.members.find(params[:id])
    @member.send_welcome = true
    if @member.can_induct?
      @member.induct!

      st = ShareTransaction.create(
        :to_account => @member.find_or_create_share_account,
        :from_account => co.share_account,
        :amount => 1
      )
      st.save!
      st.approve!
    end

    if @member.active?
      Task.where(:subject_id => @member.id, :subject_type => 'Member', :action => 'process_application').each do |task|
        task.update_attribute(:completed_at, Time.now.utc)
      end
    end

    redirect_to members_path
  end

  def confirm_eject
    @member = co.members.find(params[:id])
  end

  def eject
    @member = co.members.find(params[:id])
    @member.eject!
    flash[:notice] = "#{@member.name}'s membership has been terminated."
    redirect_to(members_path)
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
      headers = ["First name", "Last name", "Email", "Date joined", "Time of last login"]
      fields = [:first_name, :last_name, :email, :inducted_at, :last_logged_in_at]
    when Coop
      headers = ["First name", "Last name", "Email", "Shares held", "Date membership began", "Date membership ended"]
      fields = [:first_name, :last_name, :email, :shares_count, :inducted_at, :ejected_or_resigned_at]
    else
      headesr = ["First name", "Last name", "Email"]
      fields = [:first_name, :last_name, :email]
    end

    # In Ruby 1.9, FasterCSV is provided as the stdlib's CSV library.
    csv_library = defined?(FasterCSV) ? FasterCSV : CSV

    csv = csv_library.generate do |csv|
      csv << headers
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
