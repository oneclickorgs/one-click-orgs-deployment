class CoopsController < ApplicationController
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated

  layout "setup"

  def new
    @member = Member.new
    @coop = Coop.new
  end

  def create
    @coop = Coop.new(params[:coop])
    @member = @coop.members.build(params[:member])

    @coop.save!
    @member.save!

    @member.member_class = @coop.member_classes.find_by_name("Founder Member")
    @member.save!

    @member.induct!

    log_in(@member)

    redirect_to root_url(host_and_port(@coop.host))
  end

  def propose
    @coop = Coop.find(params[:id])
    authorize! :edit, @coop

    @coop.propose!
    redirect_to :back
  end
end
