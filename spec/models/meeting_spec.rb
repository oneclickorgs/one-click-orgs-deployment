require 'spec_helper'

describe Meeting do
  
  describe "associations" do
    it "belongs to organisation" do
      meeting = Meeting.make
      organisation = Organisation.make
      
      expect {meeting.organisation = organisation}.to_not raise_error
      
      meeting.save
      meeting.reload
      
      meeting.organisation.should == organisation
    end
    
    it "has many participants" do
      meeting = Meeting.make
      member = Member.make
      
      expect {meeting.participants << member}.to_not raise_error
      
      meeting.reload.participants.should == [member]
    end
  end
  
  describe "#to_event" do
    it "produces an event" do
      meeting = Meeting.make
      event = meeting.to_event
      
      event[:timestamp].should == meeting.created_at
      event[:object].should == meeting
      event[:kind].should == :meeting
    end
  end
  
  describe "handling form parameters" do
    it "handles the participant_ids attribute" do
      organisation = Company.make
      directors = organisation.members.make_n(2)
      
      meeting = organisation.meetings.make('participant_ids' => {
        directors[0].id.to_s => '1',
        directors[1].id.to_s => '2'
      })
      
      meeting.participants.should == directors
    end
    
    it "does not allow setting participants that are not in the same organisation as the meeting"
    
    it "ignores participant_ids with a value of '0'"
  end
  
end
