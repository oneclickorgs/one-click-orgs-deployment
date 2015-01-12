require 'spec_helper'

describe MeetingParticipation do
  describe "associations" do
    it "belongs to a meeting" do
      meeting_participation = MeetingParticipation.make!
      meeting = Meeting.make!
      
      expect{meeting_participation.meeting = meeting}.to_not raise_error
      
      meeting_participation.save
      meeting_participation.reload
      
      expect(meeting_participation.meeting).to eq(meeting)
    end
    
    it "belongs to a participant which is a Member" do
      meeting_participation = MeetingParticipation.make!
      member = Member.make!
      
      expect{meeting_participation.participant = member}.to_not raise_error
      
      meeting_participation.save
      meeting_participation.reload
      
      expect(meeting_participation.participant).to eq(member)
    end
  end
end
