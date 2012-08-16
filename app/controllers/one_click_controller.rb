class OneClickController < ApplicationController
  def index
    redirect_to(:action => 'dashboard')
  end

  def dashboard
    # Fetch open proposals
    @proposals = co.proposals.currently_open

    @new_proposal = co.proposals.new

    case co
    when Association
      if current_organisation.pending? || current_organisation.proposed?
        redirect_to constitution_path
        return
      end
      @add_member_proposal = co.add_member_proposals.build

      @timeline = [
        co.members.all,
        co.proposals.all,
        co.decisions.all,
        co.resignations.all
      ].flatten.map(&:to_event).compact.sort{|a, b| b[:timestamp] <=> a[:timestamp]}
    when Company
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
      @timeline = [
        co.members.all,
        co.meetings.all,
        co.resolutions,
        co.resolution_proposals
      ].flatten.map(&:to_event).compact.sort{|a, b| b[:timestamp] <=> a[:timestamp]}

      @tasks = current_user.tasks.current
    end
  end

  def checklist
    if co.active?
      redirect_to root_path
      return
    end
  end
end
