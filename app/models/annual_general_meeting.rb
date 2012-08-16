class AnnualGeneralMeeting < GeneralMeeting
  attr_accessible :electronic_voting

  has_one :election, :foreign_key => 'meeting_id'

  after_create :create_election_if_necessary
  def create_election_if_necessary
    return if election
    return unless electronic_nominations || electronic_voting

    build_election(:organisation => organisation)

    if electronic_nominations && nominations_closing_date
      election.nominations_closing_date = nominations_closing_date
    end

    if electronic_voting && voting_closing_date
      election.voting_closing_date = voting_closing_date
    end

    election.seats = organisation.directors_retiring.count

    election.save!
  end
end
