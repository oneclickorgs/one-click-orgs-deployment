class OneClickController < ApplicationController
  def index
    redirect_to(:action => 'dashboard')
  end

  def dashboard

    @new_proposal = co.proposals.new

    case co
    when Association
      if current_organisation.pending? || current_organisation.proposed?
        redirect_to constitution_path
        return
      end

      @proposals = co.proposals.currently_open

      @add_member_proposal = co.add_member_proposals.build

      @timeline = [
        co.members.all,
        co.proposals.all,
        co.decisions.all,
        co.resignations.all
      ].flatten.map(&:to_event).compact.sort{|a, b| b[:timestamp] <=> a[:timestamp]}
    when Company
      @proposals = co.proposals.currently_open
      @meeting = Meeting.new
      @directors = co.members.where(:member_class_id => co.member_classes.find_by_name('Director').id)
      @timeline = [
        co.proposals.all,
        co.decisions.all,
        co.meetings.all
      ].flatten.map(&:to_event).compact.sort{|a, b| b[:timestamp] <=> a[:timestamp]}
    when Coop
      unless co.active?
        redirect_to checklist_path
        return
      end

      @tasks = current_user.tasks.current.undismissed

      if can?(:read, BoardMeeting)
        meetings_association = co.meetings
      else
        meetings_association = co.general_meetings
      end
      @upcoming_meeting = meetings_association.upcoming.order('happened_on ASC').first
      if meetings_association.upcoming.count > 1
        @upcoming_meetings_count = meetings_association.upcoming.count - 1
      end

      @last_meeting = meetings_association.past.order('happened_on DESC').first

      @open_proposals_without_vote = co.resolutions.currently_open.reject{|p| p.vote_by(current_user)}

      @members_and_shares_tasks = current_user.tasks.current.members_or_shares_related
    end
  end

  def checklist
    if co.active?
      redirect_to root_path
      return
    end
  end
end
