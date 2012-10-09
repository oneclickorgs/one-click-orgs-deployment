class DirectorshipsController < ApplicationController
  def new
    @directorship = co.directorships.build(:elected_on => Date.today)
  end

  def external
    external_director_member_class = co.member_classes.find_by_name("External Director")
    unless external_director_member_class
      flash[:error] = "This organisation does not support appointing external directors."
      redirect_to directors_path
      return
    end

    @directorship = co.directorships.build
    @directorship.build_director(:member_class_id => external_director_member_class.id)
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
