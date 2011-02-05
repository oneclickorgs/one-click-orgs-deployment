require 'spec_helper'

describe Decision do
  describe "notifying via email" do
    context "when proposal is a Founding Proposal" do
      before(:each) do
        @decision = Decision.new
        
        VotingSystems.stub!(:get).with('Founding').and_return(@founding_voting_system = mock("founding voting system"))
        @decision.stub!(:proposal).and_return(@proposal = mock_model(Proposal))
        @proposal.stub!(:voting_system).and_return(@founding_voting_system)
        
        @members_association = [@member = mock_model(Member)]
        @decision.stub!(:organisation).and_return(@organisation = mock_model(Organisation, :members => @members_association))
        
        @email = mock("email", :deliver => nil)
      end
      
      it "sends foundation decision emails" do
        DecisionMailer.should_receive(:notify_foundation_decision).with(@member, @decision).exactly(:once).and_return(@email)
        @decision.send_email
      end
    end
  end
end
