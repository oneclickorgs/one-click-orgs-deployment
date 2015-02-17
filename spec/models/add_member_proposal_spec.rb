require 'rails_helper'

describe AddMemberProposal do
  before do
    default_association_constitution
    default_organisation
  end

  it "should persist type information" do    
    @proposal = @organisation.add_member_proposals.make!
    expect(@organisation.add_member_proposals.find(@proposal.id)).to be_kind_of(AddMemberProposal)
  end
  
  it "should send an email to the new member if proposal passes" do
    @proposal = @organisation.add_member_proposals.new
    
    expect(MembersMailer).to receive(:welcome_new_member).and_return(double('mail', :deliver => nil))
    @proposal.parameters = {:first_name=>"Paul", :last_name => "Smith", :email => "paul@example.com"}
    @proposal.enact!
  end
  
  describe "validation" do
    before(:each) do
      @proposer = @organisation.members.make!
      @proposal = @organisation.add_member_proposals.make(:proposer => @proposer)
    end
    
    it "should not validate when proposed new member is already active" do
      @existing_member = @organisation.members.make!
      @proposal.parameters = {'email' => @existing_member.email, 'first_name' => @existing_member.first_name, 'last_name' => @existing_member.last_name}
      expect(@proposal).not_to be_valid
    end
  
    it "should validate when proposed new member exists but is not active" do
      @existing_member = @organisation.members.make!
      @existing_member.eject!
    
      @proposal.parameters = {'email' => @existing_member.email, 'first_name' => @existing_member.first_name, 'last_name' => @existing_member.last_name}
      expect(@proposal).to be_valid
    end
  end
  
  describe "enacting" do
    context "when proposed new member is brand new" do
      before(:each) do
        @proposal = @organisation.add_member_proposals.make!(:parameters => {'first_name' => 'New', 'last_name' => 'Member', 'email' => "new@example.com"})
      end
      
      it "should create a new member" do
        old_member_count = @organisation.members.count
        @proposal.enact!
        expect(@organisation.members.count).to eq(old_member_count + 1)
        expect(@organisation.members.last.email).to eq('new@example.com')
      end
    end
    
    context "when proposed new member is an ex-member" do
      before(:each) do
        @ex_member = @organisation.members.make!
        @ex_member.eject!
        
        @proposal = @organisation.add_member_proposals.make!(:parameters => {'email' => @ex_member.email, 'first_name' => @ex_member.first_name, 'last_name' => @ex_member.last_name})
      end
      
      it "should reactivate the ex-member" do
        old_member_count = @organisation.members.count
        @proposal.enact!
        expect(@organisation.members.count).to eq(old_member_count)
        @ex_member.reload
        expect(@ex_member).to be_active
      end
    end
  end
  
  it "has a decision notification message" do
    expect(AddMemberProposal.new.decision_notification_message).to be_present
  end
end