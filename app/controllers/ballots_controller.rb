class BallotsController < ApplicationController
  def new
    find_election
    find_annual_general_meeting
    @ballot = @election.ballots.build
    @nominations = @election.nominations
  end

  def create
    find_election
    @ballot = @election.ballots.build(params[:ballot])
    @ballot.member = current_user
    @ballot.save!
    flash[:notice] = "Your vote has been cast."
    redirect_to root_path
  end

protected

  def find_election
    @election ||= co.elections.find(params[:election_id])
  end

  def find_annual_general_meeting
    find_election
    @annual_general_meeting ||= @election.meeting
  end
end
