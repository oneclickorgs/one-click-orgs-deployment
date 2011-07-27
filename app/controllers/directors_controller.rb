class DirectorsController < ApplicationController
  def create
    @director = co.build_director(params[:director])
    @director.save
    redirect_to members_path
  end
end
