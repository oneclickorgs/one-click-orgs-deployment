class MeetingsController < ApplicationController
  def index
    case co
    when Company
      @upcoming_meetings = co.meetings.upcoming
      @past_meetings = co.meetings.past
    when Coop
      @upcoming_meetings = co.general_meetings.upcoming
      @past_meetings = co.general_meetings.past
    end
  end

  def show
    @meeting = co.meetings.find(params[:id])

    unless can?(:read, @meeting)
      redirect_to root_path
      return
    end

    if co.is_a?(Coop)
      case @meeting
      when AnnualGeneralMeeting
        redirect_to annual_general_meeting_path(@meeting)
        return
      when GeneralMeeting
        redirect_to general_meeting_path(@meeting)
        return
      when BoardMeeting
        redirect_to board_meeting_path(@meeting)
        return
      end
    end

    @comments = @meeting.comments
    @comment = Comment.new
  end

  def create
    unless can?(:create, Meeting)
      redirect_to root_path
      return
    end

    # A Meeting must know its organisation before we
    # try to set its participants.
    @meeting = co.meetings.build
    @meeting.attributes = params[:meeting]

    @meeting.creator = current_user

    if @meeting.save
      redirect_to root_path
    else
      flash[:error] = "There was a problem saving the minutes."

      @directors = co.members.where(:member_class_id => co.member_classes.find_by_name('Director').id)

      render :action => 'new'
    end
  end
end
