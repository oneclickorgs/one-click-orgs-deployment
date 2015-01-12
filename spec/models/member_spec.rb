require 'spec_helper'
require 'lib/vote_error'

describe Member do

  before(:each) do
    Delayed::Job.delete_all

    default_association_constitution
    default_organisation

    @member = @organisation.members.make!
  end


  describe "defaults" do
    it "should be active" do
      expect(@member).to be_active
    end
  end

  describe "validation" do
    it "requires a email address" do
      @member = Member.make(:email => "")
      expect(@member).not_to be_valid
      expect(@member.errors[:email]).to be_present
    end

    it "requires a reasonable email address" do
      @member = Member.make(:email => "bob")
      expect(@member).not_to be_valid
      expect(@member.errors[:email]).to be_present

      @member.email = "bob@example"
      expect(@member).not_to be_valid
      expect(@member.errors[:email]).to be_present

      # (Invalid) double-quote character in local part
      @member.email = "bob\"@example.com"
      expect(@member).not_to be_valid
      expect(@member.errors[:email]).to be_present

      @member.email = "bob@example.com"
      expect(@member).to be_valid
    end

    it "requires a unique email address within the organisation" do
      @other_organisation = Organisation.make!
      @other_member = @other_organisation.members.make!(:email => "other@example.com")

      @fellow_member = @organisation.members.make!(:email => "fellow@example.com")

      @member = @organisation.members.make(:email => "other@example.com")
      expect(@member).to be_valid

      @member.email = "fellow@example.com"
      expect(@member).not_to be_valid
      expect(@member.errors[:email]).to be_present
    end
  end

  describe "voting" do
    before(:each) do
      @proposal = @organisation.proposals.make!(:proposer_member_id => @member.id)
    end

    it "should not allow votes on members inducted after proposal was made" do
      new_member = @organisation.members.make!(:created_at => Time.now + 1.day, :inducted_at => Time.now + 1.day)
      expect {
        new_member.cast_vote(:for, @proposal)
      }.to raise_error(VoteError)
    end

    it "should not allow additional votes" do
      expect {
        @member.cast_vote(:against, @proposal)
      }.to raise_error(VoteError)
    end
  end

  describe "creation" do
    it "should send a welcome email" do
      expect(MembersMailer).to receive(:welcome_new_member).and_return(double('mail', :deliver => nil))
      @organisation.members.create({
        :email=>'foo@example.com',
        :first_name=>'Klaus',
        :last_name=>'Haus',
        :send_welcome => true
      })
    end
  end


  describe "ejection" do
    it "should toggle active flag after ejection" do
      expect { @member.eject! }.to change(@member, :active?).from(true).to(false)
    end

    context 'when the member has a share account' do
      let(:share_account) {mock_model(ShareAccount)}

      before(:each) do
        allow(@member).to receive(:share_account).and_return(share_account)
      end

      it 'should empty their share account' do
        expect(share_account).to receive(:empty!)
        @member.eject!
      end
    end
  end

  describe "finders" do
    it "should return only active members" do
      expect(@organisation.members.active).to eq(@organisation.members.all)
      disabled = @organisation.members.make!(:state => 'inactive')
      expect(@organisation.members.active).to eq(@organisation.members.all - [disabled])
    end
  end

  describe 'scopes' do
    it 'returns active and pending members' do
      active = @organisation.members.make!(:state => 'active')
      inactive = @organisation.members.make!(:state => 'inactive')
      pending = @organisation.members.make!(:state => 'pending')
      expect(@organisation.members.active_and_pending).to include(active)
      expect(@organisation.members.active_and_pending).to include(pending)
      expect(@organisation.members.active_and_pending).not_to include(inactive)
    end
  end

  describe "name" do
    it "returns the full name for a member with first name and last name" do
      expect(Member.new(:first_name => "Bob", :last_name => "Smith").name).to eq("Bob Smith")
    end

    it "returns the first name for a member with a first name only" do
      expect(Member.new(:first_name => "Bob").name).to eq("Bob")
    end

    it "returns the last name for a member with a last name only" do
      expect(Member.new(:last_name => "Smith").name).to eq("Smith")
    end

    it "returns nil for a member with no first name and no last name" do
      expect(Member.new.name).to be_nil
    end
  end

  describe "terms and conditions acceptance" do
    context "when creating a new member" do
      before(:each) do
        @member = Member.make
      end

      it "saves a timestamp when terms are accepted" do
        @member.terms_and_conditions = '1'
        expect(@member.save).to be true
        expect(@member.terms_accepted_at).not_to be_nil
      end

      it "fails validation when terms are not accepted" do
        @member.terms_and_conditions = '0'
        expect(@member.save).to be false
      end

      it "does not save a timestamp when terms_and_conditions is not passed" do
        @member.terms_and_conditions = nil
        expect(@member.save).to be true
        expect(@member.terms_accepted_at).to be_nil
      end
    end

    context "when updating an existing member" do
      before(:each) do
        @member = Member.make!(:terms_accepted_at => Time.now.utc - 1.day)
        @original_timestamp = @member.terms_accepted_at
      end

      it "does not alter the timestamp when terms_and_conditions is nil" do
        @member.terms_and_conditions = nil
        expect(@member.save).to be true
        expect(@member.terms_accepted_at).to eq(@original_timestamp)
      end

      it "does not alter an existing timestamp when terms are accepted again" do
        @member.terms_and_conditions = '1'
        expect(@member.save).to be true
        expect(@member.terms_accepted_at).to eq(@original_timestamp)
      end

      it "fails validation when terms are not accepted" do
        @member.terms_and_conditions = '0'
        expect(@member.save).to be false
      end
    end
  end

  describe "when a pending member is ejected before they are inducted" do
    before(:each) do
      @pending_member = Member.make!(:state => 'pending', :inducted_at => nil)
      @inducted_member = Member.make!
      @ejected_member = Member.make!(:inducted_at => nil)
      @ejected_member.eject!
    end

    describe "pending" do
      it "should list the pending members" do
        expect(Member.pending.count).to eq(1)
        expect(Member.pending.first.id).to eq(@pending_member.id)
      end
    end
  end

  describe "resigning" do
    def mock_email
      double("email", :deliver => nil)
    end

    it "creates a resignation record" do
      previous_resignation_count = @member.resignations.count
      @member.resign!
      expect(@member.resignations.count).to eq(previous_resignation_count + 1)
    end

    it "sends a notification email to the other members" do
      other_members = @organisation.members.make!(3)

      other_members.each do |other_member|
        expect(MembersMailer).to receive(:notify_resignation).with(other_member, @member).and_return(mock_email)
      end

      @member.resign!
    end
  end

  describe "associations" do
    it "has many ballots" do
      @member = Member.make!
      @ballot = Ballot.make!

      expect {@member.ballots << @ballot}.to_not raise_error

      @member.reload
      @member.ballots.reload

      expect(@member.ballots).to include(@ballot)
    end

    it "has many tasks" do
      @member = Member.make!
      @task = Task.make!

      expect {@member.tasks << @task}.to_not raise_error

      @member.reload
      @member.tasks.reload

      expect(@member.tasks).to include(@task)
    end

    it "has one directorship" do
      @member = Member.make!
      @directorship = Directorship.make!

      expect {@member.directorship = @directorship}.to_not raise_error

      @member.save!
      @member.reload

      expect(@member.directorship(true)).to eq(@directorship)
    end
  end

  context "when organisation is a Coop" do
    before(:each) do
      @organisation = Coop.make!
    end

    context "on creation" do
      it "creates a task for the secretary" do
        @secretary = @organisation.members.make!(:secretary)
        expect {@member = @organisation.members.make!(:pending)}.to change{@secretary.tasks.count}.by(1)
        expect(@secretary.tasks.last.subject).to eq(@member)
      end
    end
  end

  it "records when induction happened" do
    member = Member.make!(:pending)
    member.induct!
    expect(member.inducted_at).to be_present
  end

  it "returns the count of shares owned by this member" do
    member = Member.make!
    expect(member.shares_count).to eq(0)
  end

  it "has an organisation_name attribute" do
    member = Member.make
    organisation = mock_model(Organisation, :name => 'Test org')
    allow(member).to receive(:organisation).and_return(organisation)
    expect(member.organisation_name).to eq('Test org')
  end

  describe "#contact_details_present?" do
    let(:member) {Member.new(:email => "bob@example.com", :address => "1 High Street", :phone => "01234 567 890")}

    it "returns true when all contacts details are present" do
      expect(member.contact_details_present?).to be true
    end

    it "returns false if the email address is missing" do
      member.email = ''
      expect(member.contact_details_present?).to be false
    end

    it "returns false if the address is missing" do
      member.address = ''
      expect(member.contact_details_present?).to be false
    end

    it "returns false if the phone is missing" do
      member.phone = ''
      expect(member.contact_details_present?).to be false
    end
  end
end
