require 'spec_helper'

describe Decision do
  
  describe "notifying via email" do
    before(:each) do
      @member = mock_model(Member)
      
      @decision = Decision.new
      @decision.stub_chain(:proposal, :voting_system).and_return(mock('standard voting system'))
      @decision.stub_chain(:organisation, :members, :active).and_return([@member])
      
      @mail = mock("mail", :deliver => nil)
      DecisionMailer.stub!(:notify_new_decision).and_return(@mail)
    end
    
    it "sends out an email to each member after a Decision has been made" do
      DecisionMailer.should_receive(:notify_new_decision).with(@member, @decision).and_return(@mail)
      @decision.save
    end
    
    context "when email delivery errors" do
      before(:each) do
        @mail.stub!(:deliver).and_raise(StandardError)
      end
      
      it "should not propagate the error" do
        expect {@decision.save}.to_not raise_error
      end
    end
    
    context "when proposal is a Founding Proposal" do
      before(:each) do
        @founding_voting_system = mock("founding voting system")
        VotingSystems.stub!(:get).with('Founding').and_return(@founding_voting_system)
        @decision.stub_chain(:proposal, :voting_system).and_return(@founding_voting_system)
        
        @decision.stub_chain(:organisation, :members).and_return([@member])
      end
      
      it "sends foundation decision emails" do
        DecisionMailer.should_receive(:notify_foundation_decision).with(@member, @decision).exactly(:once).and_return(@mail)
        @decision.send_email
      end
    end
  end
  
end
