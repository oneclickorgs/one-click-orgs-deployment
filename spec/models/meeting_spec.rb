require 'rails_helper'

describe Meeting do

  describe "associations" do
    it "belongs to organisation" do
      meeting = Meeting.make!
      organisation = Organisation.make!

      expect {meeting.organisation = organisation}.to_not raise_error

      meeting.save
      meeting.reload

      expect(meeting.organisation).to eq(organisation)
    end

    it "has many participants" do
      meeting = Meeting.make!
      member = Member.make!

      expect {meeting.participants << member}.to_not raise_error

      expect(meeting.reload.participants).to eq([member])
    end

    it "has many comments" do
      meeting = Meeting.make!
      comment = Comment.make!

      expect{meeting.comments << comment}.to_not raise_error

      expect(meeting.reload.comments).to eq([comment])
    end

    it "belongs to a creator" do
      meeting = Meeting.make!
      creator = Member.make!

      expect {meeting.creator = creator}.to_not raise_error

      meeting.save!
      meeting = Meeting.find(meeting.id)

      expect(meeting.creator).to eq(creator)
    end

    it "has many agenda items" do
      meeting = Meeting.make!
      agenda_item = AgendaItem.make!

      expect {meeting.agenda_items << agenda_item}.to_not raise_error

      expect(meeting.agenda_items(true)).to include(agenda_item)
    end
  end

  it "accepts nested attributes for agenda items" do
    meeting = Meeting.make
    expect {meeting.agenda_items_attributes = [{:title => 'Any Other Business'}]}.to_not raise_error
    expect(meeting.agenda_items.map(&:title)).to eq(["Any Other Business"])
  end

  describe "scopes" do
    before(:each) do
      @today = Time.now.utc
      @yesterday = Time.now.utc.advance(:days => -1)
    end

    describe "upcoming" do
      it "includes a meeting that happens today" do
        meeting = Meeting.make!(:happened_on => @today)
        expect(Meeting.upcoming).to include(meeting)
      end

      it "does not include a meeting that happened yesterday" do
        meeting = Meeting.make!(:happened_on => @yesterday)
        expect(Meeting.upcoming).not_to include(meeting)
      end
    end

    describe "past" do
      it "includes a meeting that happened yesterday" do
        meeting = Meeting.make!(:happened_on => @yesterday)
        expect(Meeting.past).to include(meeting)
      end

      it "does not include a meeting that happens today" do
        meeting = Meeting.make!(:happened_on => @today)
        expect(Meeting.past).not_to include(meeting)
      end
    end
  end

  describe "#past?" do
    let(:today) {Time.now.utc}
    let(:yesterday) {Time.now.utc.advance(:days => -1)}

    it "is true when meeting happened yesterday" do
      expect(Meeting.new(:happened_on => yesterday).past?).to be true
    end

    it "is false when the meeting is happening today" do
      expect(Meeting.new(:happened_on => today).past?).to be false
    end
  end

  describe "validations" do
    it "requires an organisation" do
      expect(Meeting.make(:organisation => nil)).not_to be_valid
    end
  end

  describe "#to_event" do
    it "produces an event" do
      meeting = Meeting.make!
      event = meeting.to_event

      expect(event[:timestamp]).to eq(meeting.created_at)
      expect(event[:object]).to eq(meeting)
      expect(event[:kind]).to eq(:meeting)
    end
  end

  describe "handling form parameters" do
    before(:each) do
      @organisation = Company.make!
      @directors = @organisation.members.make!(2)
    end

    it "handles the participant_ids attribute" do
      meeting = @organisation.meetings.make!('participant_ids' => {
        @directors[0].id.to_s => '1',
        @directors[1].id.to_s => '1'
      })

      expect(meeting.participants.length).to eq(2)
      expect(meeting.participants).to include(@directors[0])
      expect(meeting.participants).to include(@directors[1])
    end

    it "does not allow setting participants that are not in the same organisation as the meeting" do
      other_organisation = Company.make!
      other_director = other_organisation.members.make!

      meeting = @organisation.meetings.make!('participant_ids' => {
        @directors[0].id.to_s => '1',
        other_director.id.to_s => '1'
      })

      expect(meeting.participants.length).to eq(1)
      expect(meeting.participants).to include(@directors[0])
      expect(meeting.participants).not_to include(other_director)
    end

    it "ignores participant_ids with a value of '0'" do
      meeting = @organisation.meetings.make!('participant_ids' => {
        @directors[0].id.to_s => '1',
        0 => '1'
      })

      expect(meeting.participants.length).to eq(1)
    end
  end

  describe "notification emails" do
    it "sends notification emails upon creation" do
      @company = Company.make!
      @members = @company.members.make!(3)
      @mail = double("mail", :deliver => nil)

      @meeting = @company.meetings.make

      @members.each do |member|
        expect(MeetingMailer).to receive(:notify_creation).with(member, @meeting).and_return(@mail)
      end

      @meeting.save!
    end
  end

end
