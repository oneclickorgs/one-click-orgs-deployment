require 'spec_helper'

describe Minute do

  it "has a meeting_class attribute" do
    minute = Minute.new
    expect {minute.meeting_class = 'GeneralMeeting'}.to_not raise_error
    minute.meeting_class.should == 'GeneralMeeting'
  end

  describe "delegation" do
    let(:meeting) {mock_model(Meeting, :happened_on => 'date of meeting', :minutes => "Discussion happened.").as_new_record}
    let(:minute) {Minute.new(:meeting => meeting)}

    it "delegates #persisted? to the meeting" do
      minute.persisted?.should be_false

      meeting.stub(:persisted?).and_return(true)

      minute.persisted?.should be_true
    end

    it "delegates happened_on to the meeting" do
      minute.happened_on.should == 'date of meeting'
    end

    it "delegates multi-parameter date assignment for happened_on to the meeting" do
      meeting.should_receive(:"happened_on=")

      minute.attributes = {'happened_on(1i)' => '2012', 'happened_on(2i)' => '8', 'happened_on(3i)' => '18'}
    end

    it "delegates minutes to the meeting" do
      minute.minutes.should == "Discussion happened."
    end
  end

end
