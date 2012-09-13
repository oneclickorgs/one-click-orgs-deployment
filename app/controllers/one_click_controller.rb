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

      @tasks = current_user.tasks.current

      @upcoming_meeting = co.meetings.upcoming.order('happened_on ASC').first
      if co.meetings.upcoming.count > 1
        @upcoming_meetings_count = co.meetings.upcoming.count - 1
      end

      @last_meeting = co.meetings.past.order('happened_on DESC').first

      @open_proposals_without_vote = co.proposals.currently_open.reject{|p| p.vote_by(current_user)}
    end
  end

  def checklist
    if co.active?
      redirect_to root_path
      return
    end
  end
end
