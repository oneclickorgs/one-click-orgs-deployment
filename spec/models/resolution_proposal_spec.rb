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
  
  describe "enacting" do
    before(:each) do
      @resolution_proposal = ResolutionProposal.make!

      @resolutions_association = mock("resolutions association")
      @resolution_proposal.stub_chain(:organisation, :resolutions).and_return(@resolutions_association)

      @resolution = mock_model(Resolution)
      @resolution.stub(:proposer=)
      @resolution.stub(:description=)
      @resolution.stub(:save!)

      @resolutions_association.stub(:build).and_return(@resolution)
    end

    it "builds a new resolution" do
      @resolutions_association.should_receive(:build).and_return(@resolution)
      @resolution_proposal.enact!
    end

    it "sets the new resolution's proposer to the existing proposer" do
      @resolution.should_receive(:proposer=).with(@resolution_proposal.proposer)
      @resolution_proposal.enact!
    end

    it "sets the new resolution's description" do
      @resolution.should_receive(:description=).with(@resolution_proposal.description)
      @resolution_proposal.enact!
    end

    it "saves the new resolution" do
      @resolution.should_receive(:save!)
      @resolution_proposal.enact!
    end
  end

end
