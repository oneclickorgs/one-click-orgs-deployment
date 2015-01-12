require 'spec_helper'

describe Election do

  describe "closing" do
    before(:each) do
      @organisation = Coop.make!
      @election = Election.make!(:state => :open, :seats => 2)

      @election.nominees << @organisation.members.make!(:first_name => "Castor")
      @election.nominees << @organisation.members.make!(:first_name => "Pollux")
      @election.nominees << @organisation.members.make!(:first_name => "Helen")

      nomination_ids = @election.nominations(true).map(&:id)
      @balloting_members = @organisation.members.make(6)

      @election.ballots.make!(
        :member => @balloting_members[0],
        :ranking => [nomination_ids[0], nomination_ids[1]]
      )
      @election.ballots.make!(
        :member => @balloting_members[1],
        :ranking => [nomination_ids[0], nomination_ids[1]]
      )
      @election.ballots.make!(
        :member => @balloting_members[2],
        :ranking => [nomination_ids[0], nomination_ids[1]]
      )
      @election.ballots.make!(
        :member => @balloting_members[3],
        :ranking => [nomination_ids[0], nomination_ids[1]]
      )
      @election.ballots.make!(
        :member => @balloting_members[4],
        :ranking => [nomination_ids[2]]
      )
      @election.ballots.make!(
        :member => @balloting_members[5],
        :ranking => [nomination_ids[2]]
      )

      @election.close!
    end

    it "elects the correct nominees" do
      elected_names = @election.elected_nominees.map(&:first_name)

      expect(elected_names).to include('Castor')
      expect(elected_names).to include('Helen')
    end

    it "defeats the correct nominees" do
      expect(@election.defeated_nominees.map(&:first_name)).to eq(['Pollux'])
    end
  end

  describe "elected and defeated nominees" do
    let(:election) {Election.make!(:state => :closed)}
    let(:elected_nominee) {mock_model(Member)}
    let(:defeated_nominee) {mock_model(Member)}
    let(:nominations) {double("nominations",
      :elected => [mock_model(Nomination, :nominee => elected_nominee)],
      :defeated => [mock_model(Nomination, :nominee => defeated_nominee)]
    )}

    before(:each) do
      allow(election).to receive(:nominations).and_return(nominations)
    end

    describe "elected_nominees" do
      it "returns the nominees who were elected" do
        expect(election.elected_nominees).to include(elected_nominee)
      end

      it "does not return the nominees who were defeated" do
        expect(election.elected_nominees).not_to include(defeated_nominee)
      end
    end

    describe "defeated_nominees" do
      it "returns the nominees who were defeated" do
        expect(election.defeated_nominees).to include(defeated_nominee)
      end

      it "does not return the nominees who were elected" do
        expect(election.defeated_nominees).not_to include(elected_nominee)
      end
    end
  end

  describe "associations" do
    it "has many nominees" do
      @election = Election.make!
      @nominee = Member.make!

      expect {@election.nominees << @nominee}.to_not raise_error

      @election.reload
      @election.nominees.reload

      expect(@election.nominees).to include(@nominee)
    end

    it "has many ballots" do
      @election = Election.make!
      @ballot = Ballot.make!

      expect {@election.ballots << @ballot}.to_not raise_error

      @election.reload
      @election.ballots.reload

      expect(@election.ballots).to include(@ballot)
    end

    it "has many nominations" do
      @election = Election.make!
      @nomination = Nomination.make!

      expect {@election.nominations << @nomination}.to_not raise_error

      @election.reload
      @election.nominations.reload

      expect(@election.nominations).to include(@nomination)
    end

    it "belongs to an organisation" do
      @election = Election.make!
      @organisation = Coop.make!

      expect {@election.organisation = @organisation}.to_not raise_error

      @election.save!
      @election.reload

      expect(@election.organisation(true)).to eq(@organisation)
    end
  end

  describe "states" do
    it "is in the draft state upon creation" do
      @election = Election.new
      expect(@election.state).to eq('draft')
    end

    it "moves to the open state when it is started" do
      @election = Election.make
      @election.start!
      expect(@election.state).to eq('open')
    end

    it "moves to the closed state when it is closed" do
      @election = Election.make
      @election.state = 'open'
      @election.close!
      expect(@election.state).to eq('closed')
    end
  end

  describe "mass assignment" do
    it "allows mass-assignment of 'organisation'" do
      expect{Election.new(:organisation => mock_model(Organisation))}.to_not raise_error
    end
  end

  describe "tasks" do
    describe "on closing" do
      let(:election) {Election.make(:state => :open)}
      let(:members) {[mock_model(Member, :tasks => tasks)]}
      let(:tasks) {double("tasks")}

      before(:each) do
        election.stub_chain(:organisation, :members).and_return(members)
      end

      it "creates a 'view result' task for each member" do
        expect(tasks).to receive(:create).with(hash_including(:subject => election, :action => :view_result))
        election.close!
      end
    end
  end

  describe "election closer" do
    before(:each) do
      @past_election = Election.make!(:voting_closing_date => 1.day.ago, :state => :open)
      @future_election = Election.make!(:voting_closing_date => 5.minutes.from_now, :state => :open)
    end

    it "closes elections with a close date in the past" do
      Election.close_elections
      expect(@past_election.reload).to be_closed
    end

    it "does not close elections with a close date in the future" do
      Election.close_elections
      expect(@future_election.reload).to be_open
    end
  end

end
