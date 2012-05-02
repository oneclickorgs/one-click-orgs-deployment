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
  end
  
end
