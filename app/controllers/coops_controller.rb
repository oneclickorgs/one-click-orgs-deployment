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
    
    @coop.save
    @member.save
    
    log_in(@member)
    
    redirect_to root_url(host_and_port(@coop.host))
  end
end
