require 'spec_helper'

describe EjectMemberProposal do
  before do 
    default_association_constitution
    default_organisation
  end
    
  it "should use the membership voting system" do
    @organisation.clauses.set_text!('membership_voting_system', 'Veto')
    expect(@organisation.eject_member_proposals.new.voting_system).to eq(VotingSystems::Veto)
  end
  
  it "should eject the member after passing, disabling the account" do
    @m = @organisation.members.make!    
    
    @p = @organisation.eject_member_proposals.new
    expect(@m).to be_active
    passed_proposal(@p, 'member_id' => @m.id ).call
    
    #FIXME make proposals more testable by avoiding loading of models
    #@m.should_receive(:eject!)
    
    @m.reload
    expect(@m).not_to be_active
  end  
  
  it "has a decision notification message" do
    expect(EjectMemberProposal.new.decision_notification_message).to be_present
  end
end
