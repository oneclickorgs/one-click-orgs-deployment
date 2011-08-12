require 'spec_helper'

describe Company do
  
  describe "associations" do
    it "has many meetings" do
      @company = Company.make
      @meeting = Meeting.make
      
      expect {@company.meetings << @meeting}.to_not raise_error
      
      @company.reload.meetings.should == [@meeting]
    end
    
    it "has many directors, which are really members" do
      @company = Company.make
      @member = Member.make(:organisation => @company)
      
      @company.reload
      @company.directors.first.should be_a(Director)
    end
  end
  
  describe "fake association builders" do
    it "can build a director" do
      @company = Company.make
      @director = @company.build_director(:email => "bob@example.com")
      @director.should be_a(Director)
      @director.email.should == "bob@example.com"
      @director.member_class.name.should == 'Director'
      @director.should be_active
    end
  end
  
  describe "defaults" do
    describe "default member classes" do
      it "creates a 'Director' member class" do
        @company = Company.make
        @company.member_classes.find_by_name('Director').should be_present
      end
    end
    
    it "sets a default voting system of absolute majority" do
      @company = Company.make
      @company.constitution.voting_system.should == VotingSystems::AbsoluteMajority
    end
    
    it "sets a default voting period of 7 days" do
      @company = Company.make
      @company.constitution.voting_period.should == 7.days
    end
  end
  
end
