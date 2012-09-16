class DirectorsController < ApplicationController
  def index
    @directors = co.directors
    @offices = co.offices

    @tasks = current_user.tasks.current.directors_related

    respond_to do |format|
      format.html
      format.pdf {
        generate_pdf("Directors")
      }
    end
  end

  def create
    if can?(:create, Director)
      @director = co.build_director(params[:director])
      @director.send_welcome = true
      if @director.save
        @director.send_new_director_notifications
      else
        flash[:error] = "There was a problem saving the new director."
        render :action => 'new'
        return
      end
    end

    redirect_to members_path
  end

  def stand_down
    @director = co.directors.find(params[:id])
    @director.update_attributes(params[:director])
    @director.eject!
    @director.send_stand_down_notification_emails
    redirect_to members_path
  end
end
