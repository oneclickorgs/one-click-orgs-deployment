require 'spec_helper'

describe Company do
  
  describe "associations" do
    it "has many meetings" do
      @company = Company.make
      @meeting = Meeting.make
      
      expect {@company.meetings << @meeting}.to_not raise_error
      
      @company.reload.meetings.should == [@meeting]
    end
  end
  
  describe "defaults" do
    describe "default member classes" do
      it "creates a 'Director' member class" do
        @company = Company.make
        @company.member_classes.find_by_name('Director').should be_present
      end
    end
    
    it "sets a default voting system of simple majority" do
      @company = Company.make
      @company.constitution.voting_system.should == VotingSystems::RelativeMajority
    end
    
    it "sets a default voting period of 7 days" do
      @company = Company.make
      @company.constitution.voting_period.should == 7.days
    end
  end
  
end
