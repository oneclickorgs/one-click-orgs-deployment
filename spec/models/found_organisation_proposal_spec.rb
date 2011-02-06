require 'spec_helper'

describe FoundOrganisationProposal do
  it "uses the Founding voting system" do
    FoundOrganisationProposal.new.voting_system.should == VotingSystems::Founding
  end
  
  describe "validation" do
    before(:each) do
      @proposal = FoundOrganisationProposal.new(:proposer => mock_model(Member), :title => "Title")
      @proposal.organisation = @organisation = mock_model(Organisation, :members => [])
      @organisation.stub!(:can_hold_founding_vote?).and_return(false)
    end
    
    it "fails on create if the organisation is not ready for a founding vote" do
      @organisation.should_receive(:can_hold_founding_vote?).and_return(false)
      @proposal.save.should be_false
    end
    
    it "succeeds on create if the organisation is ready for a founding vote" do
      @organisation.should_receive(:can_hold_founding_vote?).and_return(true)
      @proposal.save.should be_true
    end
    
    it "succeeds on update regardless of readiness of organisation" do
      @organisation.stub!(:can_hold_founding_vote?).and_return(true)
      @proposal.save!
      
      @organisation.stub!(:can_hold_founding_vote?).and_return(false)
      @proposal.save.should be_true
    end
  end
end
