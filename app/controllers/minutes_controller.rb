class MinutesController < ApplicationController
  def new
    @minute = co.build_minute
    @meeting_class_options_for_select = co.meeting_classes.map{|klass| [klass.description, klass.name]}
    @members = co.members
    @members_for_autocomplete = @members.map{|m| {:value => m.name, :id => m.id} }
  end

  def create
    @minute = co.build_minute(params[:minute])
    @minute.save
    redirect_to meetings_path
  end
end
