class CompaniesController < ApplicationController
  skip_before_filter :ensure_organisation_exists
  skip_before_filter :ensure_authenticated
  
  layout 'setup'
  
  def new
    @member = Member.new
    @company = Company.new
  end
  
  def create
    @company = Company.new(params[:company])
    @company.save
    @member = @company.members.build(params[:member])
    @member.member_class = @company.member_classes.find_by_name('Director')
    @member.save
    log_in(@member)
    redirect_to root_url(:host => @company.host)
  end
end
