class DirectorsController < ApplicationController
  def create
    @director = co.build_director(params[:director])
    if @director.save
			@director.organisation.members.each do |member|
				MembersMailer.new_director_notification(member, @director).deliver 
			end
		end
    redirect_to members_path
  end
end
