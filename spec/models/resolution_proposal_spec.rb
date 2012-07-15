require 'spec_helper'

describe ResolutionProposal do
  
  describe "automatic title" do
    it "automatically sets the title based on the description" do
      @resolution_proposal = ResolutionProposal.make(:title => nil, :description => "A description of the resolution")
      @resolution_proposal.save!
      @resolution_proposal.title.should be_present
    end
  end
  
  describe "notification email" do
    before(:each) do
      @coop = Coop.make!
      @secretary = @coop.members.make!(:secretary)
      @resolution_proposal = @coop.resolution_proposals.make
    end
    
    it "is sent to the Secretary" do
      @resolution_proposal.members_to_notify.should == [@secretary]
    end
    
    it "is customised for resolution proposals" do
      @resolution_proposal.notification_email_action.should == :notify_resolution_proposal
    end
  end
  
end
