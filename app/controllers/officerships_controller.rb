class OfficershipsController < ApplicationController
  def new
    officership_attributes = {:elected_on => Date.today}
    if params[:office_id]
      officership_attributes[:office_id] = params[:office_id]
    end
    if params[:officer_id]
      officership_attributes[:officer_id] = params[:officer_id]
    end
    @officership = co.officerships.build(officership_attributes)
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
