require 'rails_helper'

describe BoardMeeting do

  describe "mass assignment" do
    it "allows mass-assignment for start_time" do
      expect {BoardMeeting.new(:start_time => "4pm")}.to_not raise_error
    end

    it "allows mass-assignment for venue" do
      expect {BoardMeeting.new(:venue => "The Meeting Hall")}.to_not raise_error
    end

    it "allows mass-assignment for agenda" do
      expect {BoardMeeting.new(:agenda => "Talk about things")}.to_not raise_error
    end
  end

  it "should not send a 'new minutes' email upon creation"

end
