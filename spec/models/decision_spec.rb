require 'rails_helper'

describe Decision do
  
  describe "notifying via email" do
    before(:each) do
      @member = mock_model(Member)
      
      @decision = Decision.new
      allow(@decision).to receive(:proposal).and_return(mock_model(Proposal))
      @decision.stub_chain(:organisation, :members, :active).and_return([@member])
      
      @mail = double("mail", :deliver => nil)
      allow(DecisionMailer).to receive(:notify_new_decision).and_return(@mail)
    end
    
    it "sends out an email to each member after a Decision has been made" do
      expect(DecisionMailer).to receive(:notify_new_decision).with(@member, @decision).and_return(@mail)
      @decision.save
    end
    
    context "when email delivery errors" do
      before(:each) do
        allow(@mail).to receive(:deliver).and_raise(StandardError)
      end
      
      it "should not propagate the error" do
        expect {@decision.save}.to_not raise_error
      end
    end
    
    context "when proposal is a Founding Proposal" do
      before(:each) do
        allow(@decision).to receive(:proposal).and_return(mock_model(FoundAssociationProposal))
        @decision.stub_chain(:organisation, :members).and_return([@member])
      end
      
      it "sends foundation decision emails" do
        expect(DecisionMailer).to receive(:notify_foundation_decision).with(@member, @decision).exactly(:once).and_return(@mail)
        @decision.save
      end
    end
  end
  
end
