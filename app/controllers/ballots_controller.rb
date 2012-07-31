class BallotsController < ApplicationController
  def new
    find_election
    @ballot = @election.ballots.build
    @nominations = @election.nominations
  end

  def create
    find_election
    @ballot = @election.ballots.build(params[:ballot])
    @ballot.member = current_user
    @ballot.save!
    redirect_to root_path
  end

protected

  def find_election
    @election = co.elections.find(params[:election_id])
  end
end
