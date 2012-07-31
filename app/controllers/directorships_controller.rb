class DirectorshipsController < ApplicationController
  def new
    @directorship = co.build_directorship
  end

  def create
    @directorship = co.build_directorship(params[:directorship])
    @directorship.save!
    redirect_to directors_path
  end

  def edit
    @directorship = Directorship.find(params[:id])
  end

  def update
    @directorship = Directorship.find(params[:id])
    @directorship.update_attributes(params[:directorship])
    @directorship.save!
    redirect_to directors_path
  end
end
