require 'rails_helper'

describe ChangeTextProposal do
  before(:each) do
    default_organisation
    @objectives = @organisation.clauses.set_integer!('voting_period', 30*60)
    @objectives = @organisation.clauses.set_text!('objectives', 'eat all the cheese')
  end
  
  it "should use the constitution voting system" do
    @organisation.clauses.set_text!('constitution_voting_system', 'Veto')
    expect(@organisation.change_text_proposals.new.voting_system).to eq(VotingSystems::Veto)
  end
  
  it "should change the objectives after successful proposal" do
    @p = @organisation.change_text_proposals.new
    
    expect(passed_proposal(@p, 'name'=>'objectives', 'value'=>'make all the yoghurt')).
      to change(@organisation.clauses, :count).by(1)
    
    expect(@organisation.clauses.get_text('objectives')).to eq('make all the yoghurt')
  end
  
  it "should not validate if text has not been changed" do
    @p = ChangeTextProposal.new(:title => "change objectives to eat all the cheese", :parameters => {'name' => 'objectives', 'value' => 'eat all the cheese'})
    @p.proposer = Member.make
    expect(@p).not_to be_valid
  end
  
  it "has a decision notification message" do
    expect(ChangeTextProposal.new.decision_notification_message).to be_present
  end
end
