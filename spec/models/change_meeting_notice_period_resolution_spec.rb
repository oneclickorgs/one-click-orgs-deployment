require 'spec_helper'

describe ChangeMeetingNoticePeriodResolution do

  before(:each) do
    @change_meeting_notice_period_resolution = ChangeMeetingNoticePeriodResolution.new
  end

  it "has a 'meeting_notice_period' attribute" do
    expect {@change_meeting_notice_period_resolution.meeting_notice_period = 32}.to_not raise_error
    @change_meeting_notice_period_resolution.meeting_notice_period.should == 32
  end

  describe "mass-assignment" do
    it "is allowed for meeting_notice_period" do
      expect {ChangeMeetingNoticePeriodResolution.new(:meeting_notice_period => 32)}.to_not raise_error
    end

    it "is allowed for pass_immediately" do
      expect {ChangeMeetingNoticePeriodResolution.new(:pass_immediately => true)}.to_not raise_error
    end
  end

  it "sets a default title" do
    @resolution = ChangeMeetingNoticePeriodResolution.make(:title => nil, :description => nil, :meeting_notice_period => 32)
    @resolution.save!
    @resolution.title.should be_present
    @resolution.title.should include('32 clear days')
  end

  describe "enacting" do
    it "changes the meeting notice period" do
      @resolution = ChangeMeetingNoticePeriodResolution.make!(:meeting_notice_period => 32)

      @resolution.organisation.should_receive(:meeting_notice_period=).with(32)

      @resolution.force_passed = true
      @resolution.close!
    end
  end

end
  