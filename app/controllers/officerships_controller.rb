class OfficershipsController < ApplicationController
  def new
    @officership = co.officerships.build
    @officership.build_office
  end

  def create
    @officership = co.officerships.build(params[:officership])
    @officership.save!
    redirect_to directors_path
  end

  def edit
    @officership = co.officerships.find(params[:id])
  end

  def update
    @officership = co.officerships.find(params[:id])
    @officership.update_attributes(params[:officership])
    redirect_to directors_path
  end
end
