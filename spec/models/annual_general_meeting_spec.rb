require 'spec_helper'

describe AnnualGeneralMeeting do

  describe "associations" do
    it "has one election" do
      @agm = AnnualGeneralMeeting.make!
      @election = Election.make!

      expect {@agm.election = @election}.to_not raise_error

      @agm.reload
      @agm.election(true).should == @election
    end
  end

  describe "creating Election upon creation" do
    before(:each) do
      @organisation = Coop.make!
      @agm = @organisation.annual_general_meetings.make
    end

    it "is done if 'electronic_nominations' is true" do
      @agm.electronic_nominations = true
      @agm.save!

      @agm.election.should be_present
      @agm.election.should be_persisted
    end

    it "is done if 'electronic_voting' is true" do
      @agm.electronic_voting = true
      @agm.save!

      @agm.election.should be_present
      @agm.election.should be_persisted
    end

    it "is not done if 'electronic_nominations' and 'electronic_voting' are false" do
      @agm.save!

      @agm.election.should_not be_present
    end

    it "sets the organisation attribute" do
      @agm.electronic_voting = true
      @agm.save!
      @agm.election.organisation.should == @organisation
    end

    it "sets the nominations_closing_date attribute" do
      @agm.electronic_nominations = true
      @agm.nominations_closing_date = @nominations_closing_date = 2.weeks.from_now.to_date
      @agm.save!

      @agm.election.nominations_closing_date.should be_present
      @agm.election.nominations_closing_date.should == @nominations_closing_date
    end

    it "sets the voting_closing_date attribute" do
      @agm.electronic_voting = true
      @agm.voting_closing_date = @voting_closing_date = 2.weeks.from_now.to_date
      @agm.save!

      @agm.election.voting_closing_date.should be_present
      @agm.election.voting_closing_date.should == @voting_closing_date
    end
  end

end
