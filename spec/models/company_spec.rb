require 'spec_helper'

describe Company do
  
  describe "associations" do
    it "has many meetings" do
      @company = Company.make!
      @meeting = Meeting.make!
      
      expect {@company.meetings << @meeting}.to_not raise_error
      
      expect(@company.reload.meetings).to eq([@meeting])
    end
    
    it "has many directors, which are really members" do
      @company = Company.make!
      @member = Member.make!(:organisation => @company)
      
      @company.reload
      expect(@company.directors.first).to be_a(Director)
    end
  end
  
  describe "fake association builders" do
    it "can build a director" do
      @company = Company.make!
      @director = @company.build_director(:email => "bob@example.com")
      expect(@director).to be_a(Director)
      expect(@director.email).to eq("bob@example.com")
      expect(@director.member_class.name).to eq('Director')
      expect(@director).to be_pending
    end
  end
  
  describe "defaults" do
    describe "default member classes" do
      it "creates a 'Director' member class" do
        @company = Company.make!
        expect(@company.member_classes.find_by_name('Director')).to be_present
      end
    end
    
    it "sets a default voting system of absolute majority" do
      @company = Company.make!
      expect(@company.constitution.voting_system).to eq(VotingSystems::AbsoluteMajority)
    end
    
    it "sets a default voting period of 7 days" do
      @company = Company.make!
      expect(@company.constitution.voting_period).to eq(7.days)
    end
  end
  
end
