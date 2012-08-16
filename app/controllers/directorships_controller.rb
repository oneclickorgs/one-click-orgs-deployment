class DirectorshipsController < ApplicationController
  def new
    @directorship = co.directorships.build(:elected_on => Date.today)
  end

  def create
    @directorship = co.directorships.build(params[:directorship])
    @directorship.save!
    redirect_to directors_path
  end

  def edit
    @directorship = co.directorships.find(params[:id])
  end

  def update
    @directorship = co.directorships.find(params[:id])
    @directorship.update_attributes(params[:directorship])
    @directorship.save!
    redirect_to directors_path
  end
end
