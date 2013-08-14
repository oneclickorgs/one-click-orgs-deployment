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

      elected_names.should include('Castor')
      elected_names.should include('Helen')
    end

    it "defeats the correct nominees" do
      @election.defeated_nominees.map(&:first_name).should == ['Pollux']
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
      election.stub(:nominations).and_return(nominations)
    end

    describe "elected_nominees" do
      it "returns the nominees who were elected" do
        election.elected_nominees.should include(elected_nominee)
      end

      it "does not return the nominees who were defeated" do
        election.elected_nominees.should_not include(defeated_nominee)
      end
    end

    describe "defeated_nominees" do
      it "returns the nominees who were defeated" do
        election.defeated_nominees.should include(defeated_nominee)
      end

      it "does not return the nominees who were elected" do
        election.defeated_nominees.should_not include(elected_nominee)
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

      @election.nominees.should include(@nominee)
    end

    it "has many ballots" do
      @election = Election.make!
      @ballot = Ballot.make!

      expect {@election.ballots << @ballot}.to_not raise_error

      @election.reload
      @election.ballots.reload

      @election.ballots.should include(@ballot)
    end

    it "has many nominations" do
      @election = Election.make!
      @nomination = Nomination.make!

      expect {@election.nominations << @nomination}.to_not raise_error

      @election.reload
      @election.nominations.reload

      @election.nominations.should include(@nomination)
    end

    it "belongs to an organisation" do
      @election = Election.make!
      @organisation = Coop.make!

      expect {@election.organisation = @organisation}.to_not raise_error

      @election.save!
      @election.reload

      @election.organisation(true).should == @organisation
    end
  end

  describe "states" do
    it "is in the draft state upon creation" do
      @election = Election.new
      @election.state.should == 'draft'
    end

    it "moves to the open state when it is started" do
      @election = Election.make
      @election.start!
      @election.state.should == 'open'
    end

    it "moves to the closed state when it is closed" do
      @election = Election.make
      @election.state = 'open'
      @election.close!
      @election.state.should == 'closed'
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
        tasks.should_receive(:create).with(hash_including(:subject => election, :action => :view_result))
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
      @past_election.reload.should be_closed
    end

    it "does not close elections with a close date in the future" do
      Election.close_elections
      @future_election.reload.should be_open
    end
  end

end
