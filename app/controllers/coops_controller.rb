class CoopsController < ApplicationController
  skip_before_filter :ensure_organisation_exists, :only => [:intro, :new, :create, :terms]
  skip_before_filter :ensure_authenticated, :only => [:intro, :new, :create, :terms]

  layout "setup"

  def intro
  end

  def new
    unless params[:skip_intro] == '1'
      redirect_to(action: :intro) and return
    end

    @member = Member.new
    @coop = Coop.new
  end

  def create
    @coop = Coop.new(params[:coop])
    @member = @coop.members.build(params[:member])

    if @coop.valid? && @member.valid?
      @coop.save!
      @member.save!

      @member.member_class = @coop.member_classes.find_by_name("Founder Member")
      @member.save!

      @member.induct!

      st = ShareTransaction.create(
        :to_account => @member.find_or_create_share_account,
        :from_account => @coop.share_account,
        :amount => 1
      )
      st.save!

      log_in(@member)

      redirect_to root_url(host_and_port(@coop.host))
    else # @coop or @member invalid
      flash[:error] = "Sorry, there was a problem with those details"
      render :action => 'new'
    end
  end

  def propose
    @coop = Coop.find(params[:id])
    authorize! :edit, @coop

    @coop.propose!
    redirect_to :back
  end

  def terms
    @page_title = "Terms of Use"
  end
end
