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

    it "has many change-meeting-notice-period resolutions" do
      @coop = Coop.make!
      @change_meeting_notice_period_resolution = ChangeMeetingNoticePeriodResolution.make!

      expect {@coop.change_meeting_notice_period_resolutions << @change_meeting_notice_period_resolution}.to_not raise_error

      @coop.reload

      @coop.change_meeting_notice_period_resolutions.should include(@change_meeting_notice_period_resolution)
    end

    it "has many change-quorum resolutions" do
      @coop = Coop.make!
      @change_quorum_resolution = ChangeQuorumResolution.make!
      expect {@coop.change_quorum_resolutions << @change_quorum_resolution}.to_not raise_error
      @coop.reload
      @coop.change_quorum_resolutions.should include(@change_quorum_resolution)
    end

    describe "directors" do
      before(:each) do
        @coop = Coop.make!
        @director = @coop.members.make!(:director)
        @member = @coop.members.make!
      end

      it "includes members who have the member class of 'Director'" do
        @coop.directors.should include(@director)
      end

      it "does not include ordinary members" do
        @coop.directors.should_not include(@members)
      end
    end

    describe "officers, officerships and offices" do
      before(:each) do
        @coop = Coop.make!
        @director = @coop.members.make!(:director)
      end

      it "can add a new office" do
        @office = Office.make!
        expect {@coop.offices << @office}.to_not raise_error
        @coop.reload
        @coop.offices.should include(@office)
      end

      it "can create a new officership on an existing office" do
        @office = @coop.offices.make!
        @officership = Officership.make!

        expect {@office.officership = @officership}.to_not raise_error

        @coop.reload
        @coop.officerships.should include(@officership)
      end
    end

    it "has many elections" do
      @coop = Coop.make!
      @election = Election.make!

      expect {@coop.elections << @election}.to_not raise_error

      @coop.reload
      @coop.elections.reload

      @coop.elections.should include(@election)
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

    it "has a 'meeting_notice_period' attribute" do
      @coop = Coop.make!
      @coop.meeting_notice_period = 32
      @coop.reload
      @coop.meeting_notice_period.should == 32
    end

    it "has a 'quorum_number' attribute" do
      @coop = Coop.make!
      @coop.quorum_number = 20
      @coop.reload
      @coop.quorum_number.should == 20
    end

    it "has a 'quorum_percentage' attribute" do
      @coop = Coop.make!
      @coop.quorum_percentage = 15
      @coop.reload
      @coop.quorum_percentage.should == 15
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

  describe "building a directorship" do
    before(:each) do
      @coop = Coop.make!
    end

    it "instantiates the directorship" do
      Directorship.should_receive(:new)
      @coop.build_directorship
    end

    it "sets the directorship's organisation to itself" do
      Directorship.should_receive(:new).with(hash_including(:organisation => @coop))
      @coop.build_directorship
    end
  end

  describe "calculating directors due to retire" do
    context "when no AGM has been held before" do
      before(:each) do
        @coop = Coop.make!
        @coop.members.make!(3, :director)
      end

      it "retires all the directors" do
        @coop.directors_retiring.should == @coop.directors
      end
    end

    context "when this is not the first AGM" do
      it "retires the one-third of the directors who have been longest in office since their last election"
    end
  end 

  describe "GM/AGM builder" do
    before(:each) do
      @coop = Coop.make!
    end

    it "creates a GeneralMeeting" do
      meeting = @coop.build_general_meeting_or_annual_general_meeting
      meeting.should be_a(GeneralMeeting)
      meeting.should_not be_a(AnnualGeneralMeeting)
    end

    it "creates an AnnualGeneralMeeting" do
      meeting = @coop.build_general_meeting_or_annual_general_meeting('annual_general_meeting' => '1')
      meeting.should be_a(AnnualGeneralMeeting)
    end
  end

end
