require 'spec_helper'

describe GeneralMeeting do

  describe "mass assignment" do
    it "allows mass-assignment of 'existing_resolutions_attributes'" do
      expect{GeneralMeeting.new(:existing_resolutions_attributes => "something")}.to_not raise_error
    end
  end

  describe "associations" do
    it "has many resolutions" do
      @general_meeting = GeneralMeeting.make!
      @resolution = Resolution.make!

      expect{@general_meeting.resolutions << @resolution}.to_not raise_error

      @general_meeting.reload
      @general_meeting.resolutions.reload

      @general_meeting.resolutions.should include(@resolution)
    end
  end

  describe "attributes" do
    it "has an 'annual_general_meeting' attribute" do
      expect{GeneralMeeting.new(:annual_general_meeting => '1')}.to_not raise_error
    end
  end

  describe "setting existing resolutions" do
    before(:each) do
      @existing_resolutions_attributes = {"0"=>{"attached"=>"1", "id"=>"7"}, "1"=>{"attached"=>"0", "id"=>"9"}}

      @meeting = GeneralMeeting.new

      Resolution.stub(:find_by_id).with(7).and_return(@resolution_7 = mock_model(Resolution))
      Resolution.stub(:find_by_id).with(9).and_return(@resolution_9 = mock_model(Resolution))
    end

    it "adds the attached resolutions to the 'resolutions' association" do
      @meeting.existing_resolutions_attributes = @existing_resolutions_attributes

      @meeting.resolutions.length.should == 1
      @meeting.resolutions.should include(@resolution_7)
      @meeting.resolutions.should_not include(@resolution_9)
    end
  end

  it "should not send a 'new minutes' email upon creation"

end
