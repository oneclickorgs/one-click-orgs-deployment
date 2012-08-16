class Election < ActiveRecord::Base
  attr_accessible :organisation

  state_machine :initial => :draft do
    event :close do
      transition :open => :closed
    end

    event :start do
      transition :draft => :open
    end

    after_transition :on => :close, :do => :after_close
  end

  belongs_to :organisation
  has_many :nominations
  has_many :nominees, :through => :nominations
  has_many :ballots

  validates_presence_of :seats

  def after_close
    run!
  end

  def elected_nominees
    return [] unless closed?
    nominations.elected.map(&:nominee)
  end

  def defeated_nominees
    return [] unless closed?
    nominations.defeated.map(&:nominee)
  end

  def self.close_elections
    # Elections with a voting closing date of today should not be closed until the end
    # of today.
    where(["voting_closing_date < ? AND state = 'open'", Date.today]).each(&:close!)
  end

  def run!
    me = Meekster::Election.new

    nomination_ids = nominations.map(&:id)

    mc = nomination_ids.map{|id| Meekster::Candidate.new(id.to_s)}

    mb = ballots.map do |b|
      ranking = b.ranking.map{|nomination_id| nomination_ids.index(nomination_id)}
      ranking = ranking.map{|index| mc[index]}
      Meekster::Ballot.new(ranking)
    end

    me.candidates = mc
    me.ballots = mb
    me.seats = seats

    me.run!

    elected = me.candidates.select{|c| c.state == :elected}
    defeated = me.candidates.select{|c| c.state == :defeated}

    elected.each do |c|
      nominations.find(c.name).elect!
    end

    defeated.each do |c|
      nominations.find(c.name).defeat!
    end
  end

  # TODO Remove this; it's for testing purposes only.
  def auto_cast_ballots
    eligible_members = organisation.members - ballots.map(&:member)
    eligible_members.each do |member|
      ballots.create(:ranking => [nominations.first.id], :member => member)
    end
  end
end
