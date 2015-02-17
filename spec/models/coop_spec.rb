require 'rails_helper'

describe Coop do

  describe "being created" do
    it "succeeds" do
      expect {Coop.make!}.to_not raise_error
    end
  end

  describe "associations" do
    let(:coop) { Coop.make! }

    it "has many board meetings" do
      @coop = Coop.make!
      @board_meeting = BoardMeeting.make!

      expect {@coop.board_meetings << @board_meeting}.to_not raise_error

      @coop.reload

      expect(@coop.board_meetings).to include(@board_meeting)
    end

    it "has many general meetings" do
      @coop = Coop.make!
      @general_meeting = GeneralMeeting.make!

      expect {@coop.general_meetings << @general_meeting}.to_not raise_error

      @coop.reload

      expect(@coop.general_meetings).to include(@general_meeting)
    end

    it "has many board resolutions" do
      @coop = Coop.make!
      @board_resolution = BoardResolution.make!

      expect {@coop.board_resolutions << @board_resolution}.to_not raise_error

      @coop.reload

      expect(@coop.board_resolutions).to include(@board_resolution)
    end

    it "has many resolution proposals" do
      @coop = Coop.make!
      @resolution_proposal = ResolutionProposal.make!

      expect {@coop.resolution_proposals << @resolution_proposal}.to_not raise_error

      @coop.reload

      expect(@coop.resolution_proposals).to include(@resolution_proposal)
    end

    it "has many change-meeting-notice-period resolutions" do
      @coop = Coop.make!
      @change_meeting_notice_period_resolution = ChangeMeetingNoticePeriodResolution.make!

      expect {@coop.change_meeting_notice_period_resolutions << @change_meeting_notice_period_resolution}.to_not raise_error

      @coop.reload

      expect(@coop.change_meeting_notice_period_resolutions).to include(@change_meeting_notice_period_resolution)
    end

    it "has many change-quorum resolutions" do
      @coop = Coop.make!
      @change_quorum_resolution = ChangeQuorumResolution.make!
      expect {@coop.change_quorum_resolutions << @change_quorum_resolution}.to_not raise_error
      @coop.reload
      expect(@coop.change_quorum_resolutions).to include(@change_quorum_resolution)
    end

    it "has many terminate-directorship resolutions" do
      coop = Coop.make!
      director = coop.directors.make!(:director)
      directorship = director.directorship
      terminate_directorship_resolution = coop.terminate_directorship_resolutions.make!(directorship_id: directorship.id)
      expect{coop.terminate_directorship_resolutions << terminate_directorship_resolution}.to_not raise_error
      coop.reload
      expect(coop.terminate_directorship_resolutions).to include(terminate_directorship_resolution)
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
        expect(@coop.directors).to include(@director)
      end

      it "includes members who have the member class of 'Secretary'" do
        expect(@coop.directors).to include(@secretary)
      end

      it "includes members who have the member class of 'External Director'" do
        expect(@coop.directors).to include(@external_director)
      end

      it "does not include ordinary members" do
        expect(@coop.directors).not_to include(@members)
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
        expect(@coop.offices).to include(@office)
      end

      it "can create a new officership on an existing office" do
        @office = @coop.offices.make!
        @officership = Officership.make!

        expect {@office.officership = @officership}.to_not raise_error

        @coop.reload
        expect(@coop.officerships).to include(@officership)
      end
    end

    it "has many elections" do
      @coop = Coop.make!
      @election = Election.make!

      expect {@coop.elections << @election}.to_not raise_error

      @coop.reload
      @coop.elections.reload

      expect(@coop.elections).to include(@election)
    end

    it "has many founder members" do
      @coop = Coop.make!
      @founder_member = @coop.members.make!(:founder_member)

      expect(@coop.founder_members).to include(@founder_member)
    end

    it 'has many general_meeting_proposals' do
      general_meeting_proposal = GeneralMeetingProposal.make!
      expect{ coop.general_meeting_proposals << general_meeting_proposal }.to_not raise_error
      coop.reload
      coop.general_meeting_proposals.reload
      expect(coop.general_meeting_proposals).to include(general_meeting_proposal)
    end
  end

  describe "defaults" do
    describe "default member classes" do
      before(:each) do
        @coop = Coop.make!
      end

      it "creates a 'Director' member class" do
        expect(@coop.member_classes.find_by_name('Director')).to be_present
      end

      it "creates a 'Founder Member' member class" do
        expect(@coop.member_classes.find_by_name('Founder Member')).to be_present
      end

      it "creates a 'Member' member class" do
        expect(@coop.member_classes.find_by_name('Member')).to be_present
      end

      describe "Secretary member class" do
        it "creates a 'Secretary' member class" do
          expect(@coop.member_classes.find_by_name('Secretary')).to be_present
        end

        it "sets the 'organisation' permission" do
          expect(@coop.member_classes.find_by_name('Secretary')).to have_permission(:organisation)
        end

        it "sets the 'share_account' permission" do
          expect(@coop.member_classes.find_by_name('Secretary')).to have_permission(:share_account)
        end
      end

      it "creates an 'External Director' member class" do
        expect(@coop.member_classes.find_by_name("External Director")).to be_present
      end
    end
  end

  describe "attributes" do
    it "has a 'name' attribute" do
      @coop = Coop.new

      @coop.name = "Coffee"
      expect(@coop.name).to eq("Coffee")
    end

    it "has a 'meeting_notice_period' attribute" do
      @coop = Coop.make!
      @coop.meeting_notice_period = 32
      @coop.reload
      expect(@coop.meeting_notice_period).to eq(32)
    end

    it "has a 'quorum_number' attribute" do
      @coop = Coop.make!
      @coop.quorum_number = 20
      @coop.reload
      expect(@coop.quorum_number).to eq(20)
    end

    it "has a 'quorum_percentage' attribute" do
      @coop = Coop.make!
      @coop.quorum_percentage = 15
      @coop.reload
      expect(@coop.quorum_percentage).to eq(15)
    end

    it "has an 'objectives' attribute" do
      @coop = Coop.make!
      @coop.objectives = "Make things"
      @coop.save!
      @coop.reload
      expect(@coop.objectives).to eq("Make things")
    end

    describe "'share_value' attribute" do
      before(:each) do
        @coop = Coop.make
      end

      it "defaults to 100" do
        expect(@coop.share_value).to eq(100)
      end

      it "is an integer value of pennies" do
        @coop.share_value = 123.45
        expect(@coop.share_value).to eq(123)
      end

      it "can handle a value given in pounds" do
        @coop.share_value_in_pounds = "0.88"
        expect(@coop.share_value).to eq(88)
      end

      it "can return a value in pounds" do
        expect(@coop.share_value_in_pounds).to eq(1.0)
      end
    end

    describe "'minimum_shareholding' attribute" do
      before(:each) do
        @coop = Coop.make
      end

      it "defaults to 1" do
        expect(@coop.minimum_shareholding).to eq(1)
      end

      it "accepts a string" do
        @coop.minimum_shareholding = "3"
        expect(@coop.minimum_shareholding).to eq(3)
      end
    end

    describe "'maximum_shareholding' attribute" do
      let(:coop) { Coop.make }

      it "returns a number greater than 0" do
        expect(coop.maximum_shareholding).to be > 0
      end

      it "adjusts based on the share value" do
        original_maximum_shareholding = coop.maximum_shareholding
        coop.share_value = coop.share_value * 2
        expect(coop.maximum_shareholding).to eq(original_maximum_shareholding / 2)
      end
    end

    describe "'interest_rate' attribute" do
      before(:each) do
        @coop = Coop.make
      end

      it "defaults to nil" do
        expect(@coop.interest_rate).to be_nil
      end

      it "accepts a string" do
        @coop.interest_rate = "1.34"
        expect(@coop.interest_rate).to eq(1.34)
      end
    end

    it "has a 'membership_application_text' attribute" do
      @coop = Coop.make
      expect {@coop.membership_application_text = "Custom text."}.to_not raise_error
      expect(@coop.membership_application_text).to eq("Custom text.")
    end
  end

  describe '#find_by_name' do
    it 'returns a Coop with the name given' do
      coop_a = Coop.make!(name: 'aaaaaa')
      Coop.make!(name: 'bbbbbb')

      expect(Coop.find_by_name('aaaaaa')).to eq(coop_a)
    end
  end

  describe "#member_eligible_to_vote?" do
    it "makes the appropriate checks about voting eligibility"
  end

  describe "#secretary" do
    it "finds the Secretary" do
      @coop = Coop.make!
      @secretary = @coop.members.make!(:secretary)
      expect(@coop.secretary).to eq(@secretary)
    end
  end

  describe "building a directorship" do
    before(:each) do
      @coop = Coop.make!
    end

    it "instantiates the directorship" do
      expect(Directorship).to receive(:new)
      @coop.build_directorship
    end

    it "sets the directorship's organisation to itself" do
      expect(Directorship).to receive(:new).with(hash_including(:organisation => @coop))
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
        expect(@coop.directors_retiring).to eq(@coop.directors)
      end
    end

    context "when this is not the first AGM" do
      before(:each) do
        @coop = Coop.make!
        @coop.annual_general_meetings.make!
      end

      # Construct `number` directors each elected one day after the last one.
      def make_directors(number)
        @coop.members.make!(number, :director)
        election_date = 2.years.ago
        @directors_in_order = []
        @coop.directors.each do |director|
          director.directorship.update_attribute(:elected_on, election_date)
          election_date = election_date.advance(days: 1)
          @directors_in_order.push(director)
        end
      end

      it "retires the one-third of the directors who have been longest in office since their last election" do
        make_directors(9)
        expect(@coop.directors_retiring).to eq(@directors_in_order[0..2])
      end

      it "rounds down if the number of directors divided by three is < i.5" do
        make_directors(10)
        # One-third of 10 is 3.33... so the nearest number is 3.
        expect(@coop.directors_retiring.count).to eq(3)
      end

      it "rounds up if the number of directors divided by three is >= i.5" do
        make_directors(11)
        # One-third of 11 is 3.66... so the nearest number is 4.
        expect(@coop.directors_retiring.count).to eq(4)
      end
    end
  end

  describe "GM/AGM builder" do
    before(:each) do
      @coop = Coop.make!
    end

    it "creates a GeneralMeeting" do
      meeting = @coop.build_general_meeting_or_annual_general_meeting
      expect(meeting).to be_a(GeneralMeeting)
      expect(meeting).not_to be_a(AnnualGeneralMeeting)
    end

    it "creates an AnnualGeneralMeeting" do
      meeting = @coop.build_general_meeting_or_annual_general_meeting('annual_general_meeting' => '1')
      expect(meeting).to be_a(AnnualGeneralMeeting)
    end
  end

  describe "#meeting_classes" do
    it "returns the classes of meeting used by this type of organisation" do
      expect(Coop.new.meeting_classes).to eq([GeneralMeeting, AnnualGeneralMeeting, BoardMeeting])
    end
  end

  describe "#build_minute" do
    it "builds a Minute" do
      coop = Coop.new
      minute = coop.build_minute
      expect(minute).to be_a(Minute)
      expect(minute.organisation).to eq(coop)
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
        expect(task.subject).to eq(member)
        expect(task.action).to eq('minimum_shareholding_missed')
      end

      it "adds a task for the secretary about the member" do
        Coop.run_daily_job
        task = coop.secretary.tasks.last
        expect(task.subject).to eq(member)
        expect(task.action).to eq('minimum_shareholding_missed')
      end
    end
  end

  describe "email notification" do
    let(:administrators) {[mock_model(Administrator, :email => 'administrator@example.com')]}
    let(:email) {double("email", :deliver => nil)}

    before(:each) do
      set_up_app
      allow(Administrator).to receive(:all).and_return(administrators)
    end

    describe "for pending Coop creation" do
      it "is sent to all Administrators" do
        administrators.each do |administrator|
          expect(CoopMailer).to receive(:notify_creation).with(administrator, anything).and_return(email)
        end
        Coop.make!(:pending)
      end
    end

    describe "for Coop proposing" do
      let(:coop) {Coop.make!(:pending)}

      it "is sent to all Administrators" do
        administrators.each do |administrator|
          expect(CoopMailer).to receive(:notify_proposed).with(administrator, coop).and_return(email)
        end
        coop.propose!
      end
    end

    describe "for Coop founding" do
      let(:founder_members) {coop.members.make!(3, :founder_member)}
      let(:coop) {Coop.make!(:proposed)}

      it "is sent to all founder members" do
        founder_members.each do |founder_member|
          expect(CoopMailer).to receive(:notify_founded).with(founder_member, coop).and_return(email)
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

      expect(coop.registration_form_filled?).to be_falsey
    end

    it "returns true when three signatories have been chosen" do
      coop.clauses.set_integer!(:reg_form_signatories_0, 1)
      coop.clauses.set_integer!(:reg_form_signatories_1, 2)
      coop.clauses.set_integer!(:reg_form_signatories_2, 3)

      expect(coop.registration_form_filled?).to be true
    end
  end

  describe "registration form" do
    let(:coop) {Coop.make!(:pending)}

    it "has a money_laundering_agreement attribute" do
      expect{coop.reg_form_money_laundering_agreement = 1}.to_not raise_error
      coop.save!
      coop.reload
      expect(coop.reg_form_money_laundering_agreement).to be true
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
        allow(coop).to receive(:members).and_return(members)

        allow(members).to receive(:find).with(111).and_return(member_111)
        allow(members).to receive(:find).with(333).and_return(member_333)
        allow(members).to receive(:find).with(444).and_return(member_444)
      end

      it "saves the first three selected signatories" do
        expect(coop).to receive(:signatories=).with([member_111, member_333, member_444])

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
        allow(coop).to receive(:clauses).and_return(clauses)
      end

      it "writes the new signatories to the clauses" do
        expect(clauses).to receive(:set_integer!).with(:reg_form_signatories_0, 111)
        expect(clauses).to receive(:set_integer!).with(:reg_form_signatories_1, 333)
        expect(clauses).to receive(:set_integer!).with(:reg_form_signatories_2, 444)

        coop.signatories = [member_111, member_333, member_444]
      end
    end
  end

  describe "#can_propose?" do
    let(:coop) {Coop.new}

    before(:each) do
      coop.stub_chain(:members, :active, :count).and_return(3)
      coop.stub_chain(:directors, :count).and_return(3)
      allow(coop).to receive(:secretary).and_return(mock_model(Member))
      allow(coop).to receive(:rules_filled?).and_return(true)
      allow(coop).to receive(:registration_form_filled?).and_return(true)
      allow(coop).to receive(:signatories_and_secretary_contact_details_present?).and_return(true)
    end

    it "returns false if the signatories' and secretary's contact details are not present" do
      allow(coop).to receive(:signatories_and_secretary_contact_details_present?).and_return(false)
      expect(coop.can_propose?).to be false
    end
  end

  describe "contact details" do
    let(:coop) {Coop.new}
    let(:signatories) {[
      mock_model(Member, :contact_details_present? => true),
      mock_model(Member, :contact_details_present? => true),
      mock_model(Member, :contact_details_present? => true)
    ]}
    let(:secretary) {mock_model(Member, :contact_details_present? => true)}

    before(:each) do
      allow(coop).to receive(:signatories).and_return(signatories)
      allow(coop).to receive(:secretary).and_return(secretary)
    end

    describe "#signatories_and_secretary_contact_details_present?" do
      it "returns true if all the contact details are present" do
        expect(coop.signatories_and_secretary_contact_details_present?).to be true
      end

      it "returns false if the secretary's contact details are missing" do
        allow(secretary).to receive(:contact_details_present?).and_return(false)
        expect(coop.signatories_and_secretary_contact_details_present?).to be false
      end

      it "returns false if any one of the signatories' contact details are missing" do
        allow(signatories[1]).to receive(:contact_details_present?).and_return(false)
        expect(coop.signatories_and_secretary_contact_details_present?).to be false
      end
    end

    describe "signatories_and_secretary_without_contact_details" do
      it "does not error if the secretary is not set yet" do
        allow(coop).to receive(:secretary).and_return(nil)
        expect{coop.signatories_and_secretary_without_contact_details}.to_not raise_error
      end
    end
  end

end
