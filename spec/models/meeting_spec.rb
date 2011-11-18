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
    
    it "has many comments" do
      meeting = Meeting.make
      comment = Comment.make
      
      expect{meeting.comments << comment}.to_not raise_error
      
      meeting.reload.comments.should == [comment]
    end
  end
  
  describe "validations" do
    it "requires an organisation"
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
    before(:each) do
      @organisation = Company.make
      @directors = @organisation.members.make_n(2)
    end
    
    it "handles the participant_ids attribute" do
      meeting = @organisation.meetings.make('participant_ids' => {
        @directors[0].id.to_s => '1',
        @directors[1].id.to_s => '1'
      })
      
      meeting.participants.length.should == 2
      meeting.participants.should include(@directors[0])
      meeting.participants.should include(@directors[1])
    end
    
    it "does not allow setting participants that are not in the same organisation as the meeting"
    
    it "ignores participant_ids with a value of '0'" do
      meeting = @organisation.meetings.make('participant_ids' => {
        @directors[0].id.to_s => '1',
        0 => '1'
      })
      
      meeting.participants.length.should == 1
    end
  end
  
  describe "notification emails" do
    it "sends notification emails upon creation" do
      @company = Company.make
      @members = @company.members.make_n(3)
      @mail = double("mail", :deliver => nil)
      
      @meeting = @company.meetings.make_unsaved
      
      @members.each do |member|
        MeetingMailer.should_receive(:notify_creation).with(member, @meeting).and_return(@mail)
      end
      
      @meeting.save!
    end
  end
  
end
