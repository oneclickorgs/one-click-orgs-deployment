class OfficesController < ApplicationController
  def create
    authorize! :create, Office

    @office = co.offices.build(params[:office])
    @office.save!
    redirect_to(directors_path)
  end
end
