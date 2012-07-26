require 'spec_helper'

describe Election do

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
  end

  describe "states" do
    it "is in the draft state upon creation" do
      @election = Election.new
      @election.state.should == 'draft'
    end

    it "moves to the open state when it is started" do
      @election = Election.new
      @election.start!
      @election.state.should == 'open'
    end

    it "moves to the closed state when it is closed" do
      @election = Election.new
      @election.state = 'open'
      @election.close!
      @election.state.should == 'closed'
    end
  end

end
