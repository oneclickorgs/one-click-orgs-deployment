require "spec_helper"

describe MeetingMailer do
  
  include ModelSpecHelper
  
  before(:each) do
    stub_app_setup
    @company = Company.make!
    @meeting = @company.meetings.make!
    @member = @company.members.make!
  end
  
  describe "notify_creation" do
    before(:each) do
      @mail = MeetingMailer.notify_creation(@member, @meeting)
    end
    
    it "has an appropriate subject" do
      @mail.subject.should include("minutes")
    end
    
    it "includes the meeting's minutes in the email body" do
      @mail.body.should include(@meeting.minutes)
    end
  
    it "includes a link to the meeting in the email body" do
      @mail.body.should include("http://#{@company.subdomain}.oneclickorgs.com/meetings/#{@meeting.id}")
    end
  end

end
