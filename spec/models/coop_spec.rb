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
        @secretary = @coop.members.make!(:secretary)
        @external_director = @coop.members.make!(:external_director)
        @member = @coop.members.make!
      end

      it "includes members who have the member class of 'Director'" do
        @coop.directors.should include(@director)
      end

      it "includes members who have the member class of 'Secretary'" do
        @coop.directors.should include(@secretary)
      end

      it "includes members who have the member class of 'External Director'" do
        @coop.directors.should include(@external_director)
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

    it "has many founder members" do
      @coop = Coop.make!
      @founder_member = @coop.members.make!(:founder_member)

      @coop.founder_members.should include(@founder_member)
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

      describe "Secretary member class" do
        it "creates a 'Secretary' member class" do
          @coop.member_classes.find_by_name('Secretary').should be_present
        end

        it "sets the 'organisation' permission" do
          @coop.member_classes.find_by_name('Secretary').should have_permission(:organisation)
        end

        it "sets the 'share_account' permission" do
          @coop.member_classes.find_by_name('Secretary').should have_permission(:share_account)
        end
      end

      it "creates an 'External Director' member class" do
        @coop.member_classes.find_by_name("External Director").should be_present
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

    it "has an 'objectives' attribute" do
      @coop = Coop.make!
      @coop.objectives = "Make things"
      @coop.save!
      @coop.reload
      @coop.objectives.should == "Make things"
    end

    describe "'share_value' attribute" do
      before(:each) do
        @coop = Coop.make
      end

      it "defaults to 100" do
        @coop.share_value.should == 100
      end

      it "is an integer value of pennies" do
        @coop.share_value = 123.45
        @coop.share_value.should == 123
      end

      it "can handle a value given in pounds" do
        @coop.share_value_in_pounds = "0.88"
        @coop.share_value.should == 88
      end

      it "can return a value in pounds" do
        @coop.share_value_in_pounds.should == 1.0
      end
    end

    describe "'minimum_shareholding' attribute" do
      before(:each) do
        @coop = Coop.make
      end

      it "defaults to 1" do
        @coop.minimum_shareholding.should == 1
      end

      it "accepts a string" do
        @coop.minimum_shareholding = "3"
        @coop.minimum_shareholding.should == 3
      end
    end

    describe "'interest_rate' attribute" do
      before(:each) do
        @coop = Coop.make
      end

      it "defaults to nil" do
        @coop.interest_rate.should be_nil
      end

      it "accepts a string" do
        @coop.interest_rate = "1.34"
        @coop.interest_rate.should == 1.34
      end
    end

    it "has a 'membership_application_text' attribute" do
      @coop = Coop.make
      expect {@coop.membership_application_text = "Custom text."}.to_not raise_error
      @coop.membership_application_text.should == "Custom text."
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

  describe "#meeting_classes" do
    it "returns the classes of meeting used by this type of organisation" do
      Coop.new.meeting_classes.should == [GeneralMeeting, AnnualGeneralMeeting, BoardMeeting]
    end
  end

  describe "#build_minute" do
    it "builds a Minute" do
      coop = Coop.new
      minute = coop.build_minute
      minute.should be_a(Minute)
      minute.organisation.should == coop
    end
  end

  describe "daily job" do
    context "when there is a member who has failed to attain the minimum shareholding in 12 months" do
      let(:coop) {Coop.make!(:minimum_shareholding => 3, :single_shareholding => false)}
      let(:member) {coop.members.make!(:inducted_at => 13.months.ago)}

      before(:each) do
        coop.members.make!(:secretary)
        member
      end

      it "adds a task for the member" do
        Coop.run_daily_job
        task = member.tasks.last
        task.subject.should == member
        task.action.should == 'minimum_shareholding_missed'
      end

      it "adds a task for the secretary about the member" do
        Coop.run_daily_job
        task = coop.secretary.tasks.last
        task.subject.should == member
        task.action.should == 'minimum_shareholding_missed'
      end
    end
  end

  describe "email notification" do
    let(:administrators) {[mock_model(Administrator, :email => 'administrator@example.com')]}
    let(:email) {double("email", :deliver => nil)}

    before(:each) do
      set_up_app
      Administrator.stub(:all).and_return(administrators)
    end

    describe "for pending Coop creation" do
      it "is sent to all Administrators" do
        administrators.each do |administrator|
          CoopMailer.should_receive(:notify_creation).with(administrator, anything).and_return(email)
        end
        Coop.make!(:pending)
      end
    end

    describe "for Coop proposing" do
      let(:coop) {Coop.make!(:pending)}

      it "is sent to all Administrators" do
        administrators.each do |administrator|
          CoopMailer.should_receive(:notify_proposed).with(administrator, coop).and_return(email)
        end
        coop.propose!
      end
    end

    describe "for Coop founding" do
      let(:founder_members) {coop.members.make!(3, :founder_member)}
      let(:coop) {Coop.make!(:proposed)}

      it "is sent to all founder members" do
        founder_members.each do |founder_member|
          CoopMailer.should_receive(:notify_founded).with(founder_member, coop).and_return(email)
        end

        coop.found!
      end
    end
  end

  describe "registration_form_filled?" do
    let(:coop) {Coop.make!(:pending)}

    before(:each) do
      # Fill in the registration details
      coop.clauses.set_integer!(:reg_form_signatories_0, 1)
      coop.clauses.set_integer!(:reg_form_signatories_1, 2)
      coop.clauses.set_integer!(:reg_form_signatories_2, 3)
      coop.clauses.set_text!(:reg_form_main_contact_name, 'foo')
      coop.clauses.set_text!(:reg_form_main_contact_address, 'foo')
      coop.clauses.set_text!(:reg_form_main_contact_phone, 'foo')
      coop.clauses.set_text!(:reg_form_main_contact_email, 'foo')
      coop.clauses.set_text!(:reg_form_money_laundering_0_name, 'foo')
      coop.clauses.set_text!(:reg_form_money_laundering_0_date_of_birth, 'foo')
      coop.clauses.set_text!(:reg_form_money_laundering_0_address, 'foo')
      coop.clauses.set_text!(:reg_form_money_laundering_0_postcode, 'foo')
      coop.clauses.set_text!(:reg_form_money_laundering_0_residency_length, 'foo')
      coop.clauses.set_text!(:reg_form_money_laundering_1_name, 'foo')
      coop.clauses.set_text!(:reg_form_money_laundering_1_date_of_birth, 'foo')
      coop.clauses.set_text!(:reg_form_money_laundering_1_address, 'foo')
      coop.clauses.set_text!(:reg_form_money_laundering_1_postcode, 'foo')
      coop.clauses.set_text!(:reg_form_money_laundering_1_residency_length, 'foo')
      coop.clauses.set_boolean!(:reg_form_money_laundering_agreement, true)

    end

    it "returns false when less than three signatories have been chosen" do
      coop.clauses.set_integer!(:reg_form_signatories_0, 1)
      coop.clauses.set_integer!(:reg_form_signatories_1, 2)
      coop.clauses.where(:name => 'reg_form_signatories_2').destroy_all

      coop.registration_form_filled?.should be_false
    end

    it "returns true when three signatories have been chosen" do
      coop.clauses.set_integer!(:reg_form_signatories_0, 1)
      coop.clauses.set_integer!(:reg_form_signatories_1, 2)
      coop.clauses.set_integer!(:reg_form_signatories_2, 3)

      coop.registration_form_filled?.should be_true
    end
  end

  describe "registration form" do
    let(:coop) {Coop.make!(:pending)}

    it "has a money_laundering_agreement attribute" do
      expect{coop.reg_form_money_laundering_agreement = 1}.to_not raise_error
      coop.save!
      coop.reload
      expect(coop.reg_form_money_laundering_agreement).to be_true
    end

    it "has attributes for the main contact" do
      expect {
        coop.reg_form_main_contact_organisation_name = "Acme Ltd"
        coop.reg_form_main_contact_name = "Bob Smith"
        coop.reg_form_main_contact_address = "1 Main Street\nLondon\nN1 1AA"
        coop.reg_form_main_contact_phone = "01234 567 890"
        coop.reg_form_main_contact_email = "bob@example.com"
      }.to_not raise_error

      coop.save!
      coop_id = coop.id
      coop = Coop.find(coop_id) # Create a new instance, so that memo-ised attributes have to be looked up fresh from the database.

      expect(coop.reg_form_main_contact_organisation_name).to eq("Acme Ltd")
      expect(coop.reg_form_main_contact_name).to eq("Bob Smith")
      expect(coop.reg_form_main_contact_address).to eq("1 Main Street\nLondon\nN1 1AA")
      expect(coop.reg_form_main_contact_phone).to eq("01234 567 890")
      expect(coop.reg_form_main_contact_email).to eq("bob@example.com")
    end

    it "has attributes for the financial contact" do
      expect {
        coop.reg_form_financial_contact_name = "Jane Baker"
        coop.reg_form_financial_contact_phone = "020 7777 7777"
        coop.reg_form_financial_contact_email = "jane@example.com"
      }.to_not raise_error

      coop.save!
      coop_id = coop.id
      coop = Coop.find(coop_id) # Create a new instance, so that memo-ised attributes have to be looked up fresh from the database.

      expect(coop.reg_form_financial_contact_name).to eq("Jane Baker")
      expect(coop.reg_form_financial_contact_phone).to eq("020 7777 7777")
      expect(coop.reg_form_financial_contact_email).to eq("jane@example.com")
    end

    it "has attributes for the money laundering contacts" do
      expect {
        coop.reg_form_money_laundering_0_name = "Bob Smith"
        coop.reg_form_money_laundering_0_date_of_birth = "1 January 1970"
        coop.reg_form_money_laundering_0_address = "1 Main Street"
        coop.reg_form_money_laundering_0_postcode = "N1 1AA"
        coop.reg_form_money_laundering_0_residency_length = "6 years"

        coop.reg_form_money_laundering_1_name = "Jane Baker"
        coop.reg_form_money_laundering_1_date_of_birth = "1 May 1980"
        coop.reg_form_money_laundering_1_address = "40 High Street"
        coop.reg_form_money_laundering_1_postcode = "SW1 1AA"
        coop.reg_form_money_laundering_1_residency_length = "15 years"
      }.to_not raise_error

      coop.save!
      coop_id = coop.id
      coop = Coop.find(coop_id) # Create a new instance, so that memo-ised attributes have to be looked up fresh from the database.

      expect(coop.reg_form_money_laundering_0_name).to eq("Bob Smith")
      expect(coop.reg_form_money_laundering_0_date_of_birth).to eq("1 January 1970")
      expect(coop.reg_form_money_laundering_0_address).to eq("1 Main Street")
      expect(coop.reg_form_money_laundering_0_postcode).to eq("N1 1AA")
      expect(coop.reg_form_money_laundering_0_residency_length).to eq("6 years")

      expect(coop.reg_form_money_laundering_1_name).to eq("Jane Baker")
      expect(coop.reg_form_money_laundering_1_date_of_birth).to eq("1 May 1980")
      expect(coop.reg_form_money_laundering_1_address).to eq("40 High Street")
      expect(coop.reg_form_money_laundering_1_postcode).to eq("SW1 1AA")
      expect(coop.reg_form_money_laundering_1_residency_length).to eq("15 years")
    end
  end

  describe "signatories" do
    let(:coop) {Coop.make!(:pending)}
    let(:member_111) {mock_model(Member, :id => 111)}
    let(:member_333) {mock_model(Member, :id => 333)}
    let(:member_444) {mock_model(Member, :id => 444)}

    describe "reg_form_signatories_attributes=" do
      let(:members) {double("members association")}

      before(:each) do
        coop.stub(:members).and_return(members)

        members.stub(:find).with(111).and_return(member_111)
        members.stub(:find).with(333).and_return(member_333)
        members.stub(:find).with(444).and_return(member_444)
      end

      it "saves the first three selected signatories" do
        coop.should_receive(:signatories=).with([member_111, member_333, member_444])

        coop.reg_form_signatories_attributes = {
          '0' => {'selected' => '1', 'id' => '111'},
          '1' => {'selected' => '0', 'id' => '222'},
          '2' => {'selected' => '1', 'id' => '333'},
          '3' => {'selected' => '1', 'id' => '444'},
          '4' => {'selected' => '1', 'id' => '555'}
        }
      end
    end

    describe "signatories=" do
      let(:clauses) {double("clauses association")}

      before(:each) do
        coop.stub(:clauses).and_return(clauses)
      end

      it "writes the new signatories to the clauses" do
        clauses.should_receive(:set_integer!).with(:reg_form_signatories_0, 111)
        clauses.should_receive(:set_integer!).with(:reg_form_signatories_1, 333)
        clauses.should_receive(:set_integer!).with(:reg_form_signatories_2, 444)

        coop.signatories = [member_111, member_333, member_444]
      end
    end
  end

  describe "#can_propose?" do
    let(:coop) {Coop.new}

    before(:each) do
      coop.stub_chain(:members, :active, :count).and_return(3)
      coop.stub_chain(:directors, :count).and_return(3)
      coop.stub(:secretary).and_return(mock_model(Member))
      coop.stub(:rules_filled?).and_return(true)
      coop.stub(:registration_form_filled?).and_return(true)
      coop.stub(:signatories_and_secretary_contact_details_present?).and_return(true)
    end

    it "returns false if the signatories' and secretary's contact details are not present" do
      coop.stub(:signatories_and_secretary_contact_details_present?).and_return(false)
      expect(coop.can_propose?).to be_false
    end
  end

  describe "#signatories_and_secretary_contact_details_present?" do
    let(:coop) {Coop.new}
    let(:signatories) {[
      mock_model(Member, :contact_details_present? => true),
      mock_model(Member, :contact_details_present? => true),
      mock_model(Member, :contact_details_present? => true)
    ]}
    let(:secretary) {mock_model(Member, :contact_details_present? => true)}

    before(:each) do
      coop.stub(:signatories).and_return(signatories)
      coop.stub(:secretary).and_return(secretary)
    end

    it "returns true if all the contact details are present" do
      expect(coop.signatories_and_secretary_contact_details_present?).to be_true
    end

    it "returns false if the secretary's contact details are missing" do
      secretary.stub(:contact_details_present?).and_return(false)
      expect(coop.signatories_and_secretary_contact_details_present?).to be_false
    end

    it "returns false if any one of the signatories' contact details are missing" do
      signatories[1].stub(:contact_details_present?).and_return(false)
      expect(coop.signatories_and_secretary_contact_details_present?).to be_false
    end
  end

end
