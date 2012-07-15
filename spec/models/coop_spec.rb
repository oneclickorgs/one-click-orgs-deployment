require 'spec_helper'

describe Coop do
  
  describe "being created" do
    it "succeeds" do
      expect {Coop.make!}.to_not raise_error
    end
  end
  
  describe "associations" do
    it "has many board meetings" do
      @coop = Coop.make!
      @board_meeting = BoardMeeting.make!
      
      expect {@coop.board_meetings << @board_meeting}.to_not raise_error
      
      @coop.reload
      
      @coop.board_meetings.should include(@board_meeting)
    end
    
    it "has many general meetings" do
      @coop = Coop.make!
      @general_meeting = GeneralMeeting.make!
      
      expect {@coop.general_meetings << @general_meeting}.to_not raise_error
      
      @coop.reload
      
      @coop.general_meetings.should include(@general_meeting)
    end
    
    it "has many board resolutions" do
      @coop = Coop.make!
      @board_resolution = BoardResolution.make!
      
      expect {@coop.board_resolutions << @board_resolution}.to_not raise_error
      
      @coop.reload
      
      @coop.board_resolutions.should include(@board_resolution)
    end
    
    it "has many resolution proposals" do
      @coop = Coop.make!
      @resolution_proposal = ResolutionProposal.make!
      
      expect {@coop.resolution_proposals << @resolution_proposal}.to_not raise_error
      
      @coop.reload
      
      @coop.resolution_proposals.should include(@resolution_proposal)
    end
  end
  
  describe "defaults" do
    describe "default member classes" do
      before(:each) do
        @coop = Coop.make!
      end
      
      it "creates a 'Director' member class" do
        @coop.member_classes.find_by_name('Director').should be_present
      end
      
      it "creates a 'Founder Member' member class" do
        @coop.member_classes.find_by_name('Founder Member').should be_present
      end
      
      it "creates a 'Member' member class" do
        @coop.member_classes.find_by_name('Member').should be_present
      end
      
      it "creates a 'Secretary' member class" do
        @coop.member_classes.find_by_name('Secretary').should be_present
      end
    end
  end
  
  describe "attributes" do
    it "has a 'name' attribute" do
      @coop = Coop.new
      
      @coop.name = "Coffee"
      @coop.name.should == "Coffee"
    end
  end
  
  describe "#member_eligible_to_vote?" do
    it "makes the appropriate checks about voting eligibility"
  end
  
  describe "#secretary" do
    it "finds the Secretary" do
      @coop = Coop.make!
      @secretary = @coop.members.make!(:secretary)
      
      @coop.secretary.should == @secretary
    end
  end
end
