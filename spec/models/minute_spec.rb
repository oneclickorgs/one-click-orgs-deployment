require 'rails_helper'

describe Minute do

  it "has a meeting_class attribute" do
    minute = Minute.new
    expect {minute.meeting_class = 'GeneralMeeting'}.to_not raise_error
    expect(minute.meeting_class).to eq('GeneralMeeting')
  end

  describe "delegation" do
    let(:meeting) {mock_model(Meeting, :happened_on => 'date of meeting', :minutes => "Discussion happened.").as_new_record}
    let(:minute) {Minute.new(:meeting => meeting)}

    it "delegates #persisted? to the meeting" do
      expect(minute.persisted?).to be false

      allow(meeting).to receive(:persisted?).and_return(true)

      expect(minute.persisted?).to be true
    end

    it "delegates happened_on to the meeting" do
      expect(minute.happened_on).to eq('date of meeting')
    end

    it "delegates multi-parameter date assignment for happened_on to the meeting" do
      expect(meeting).to receive(:"happened_on=")

      minute.attributes = {'happened_on(1i)' => '2012', 'happened_on(2i)' => '8', 'happened_on(3i)' => '18'}
    end

    it "delegates minutes to the meeting" do
      expect(minute.minutes).to eq("Discussion happened.")
    end
  end

end
