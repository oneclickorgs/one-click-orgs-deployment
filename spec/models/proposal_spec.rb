require 'spec_helper'

describe Proposal do
  
  before(:each) do
    Delayed::Job.delete_all 
        
    default_association_constitution  
    default_association
    default_association_voting_systems
    default_association_member_class
    
    @member = @organisation.members.make(:member_class => @default_member_class)
    
    @mail = mock('mail', :deliver => nil)
    
    ProposalMailer.stub!(:notify_creation).and_return(@mail)
    DecisionMailer.stub!(:notify_new_decision).and_return(@mail)
  end
  
  describe "model associations" do
    describe "comments" do
      it "orders by creation timestamp" do
        comments = [
          Comment.make(:created_at => 1.day.ago, :body => "C"),
          Comment.make(:created_at => 5.days.ago, :body => "A"),
          Comment.make(:created_at => 3.days.ago, :body => "B")
        ]
        proposal = @organisation.proposals.make
        proposal.comments << comments
        proposal.comments.map(&:body).should == ["A", "B", "C"]
      end
    end
  end
  
  it "should close early proposals" do
    member_0, member_1, member_2 = @organisation.members.make_n(3, :member_class => @default_member_class)
    member_3, member_4 = @organisation.members.make_n(2, :created_at => Time.now + 1.day, :member_class => @default_member_class)
    
    proposal = @organisation.proposals.create!(:proposer_member_id => member_1.id, :title => 'test', :parameters => nil) 
    [member_0, member_2].each { |m| m.cast_vote(:for, proposal)}
    
    lambda {
      @organisation.proposals.close_early_proposals.should include(proposal)
    }.should change(Decision, :count).by(1)
    
    proposal.decision.should_not be_nil    
  end
  
  it "should close due proposals" do    
    proposal = @organisation.proposals.make(:proposer_member_id => @member.id, :close_date=>Time.now - 1.day, :parameters => nil)  
    @organisation.proposals.close_due_proposals.should include(proposal)
    
    proposal.reload
    proposal.should be_closed     
  end
  
  it "should send out an email to each member after a Proposal has been made" do
    @organisation.members.count.should > 0
    @member.member_class.set_permission!(:vote, true)
    
    ProposalMailer.should_receive(:notify_creation).and_return(mock('email', :deliver => nil))
    @organisation.proposals.make(:proposer => @member)
  end
  
  describe "closing" do
    before(:each) do
      @organisation.members.count.should > 0

      @p = @organisation.proposals.make(:proposer => @member)
      @p.stub!(:passed?).and_return(true)
      # @p.stub!(:create_decision).and_return(@decision = mock_model(Decision, :send_email => nil))
    end
    
    context "when proposal is a Founding Proposal" do
      before(:each) do
        @organisation.stub!(:can_hold_founding_vote?).and_return(true)
        @p = FoundAssociationProposal.make(:proposer => @member, :organisation => @organisation)
        @p.stub!(:passed?).and_return(true)
        @p.stub!(:create_decision).and_return(@decision = mock_model(Decision, :send_email => nil))
        
        association_is_proposed
      end
      
      it "creates a decision" do
        @p.should_receive(:create_decision)
        @p.close!
      end
    end
  end
  
  describe "to_event" do
    it "should list open proposals as 'proposal's" do
      @organisation.proposals.make(:state => 'open').to_event[:kind].should == :proposal
    end
    
    it "should list closed, accepted proposals as 'proposal's" do
      @organisation.proposals.make(:state => 'accepted').to_event[:kind].should == :proposal
    end
    
    it "should list closed, rejected proposals as 'failed proposal's" do
      proposal = @organisation.proposals.make(:state => 'rejected')
      proposal.open?.should be_false
      
      proposal.to_event[:kind].should == :failed_proposal
    end
  end
  
  describe "vote counting" do
    before(:each) do
      @proposal = @organisation.proposals.create
      3.times{Vote.create(:proposal => @proposal, :for => true)}
      4.times{Vote.create(:proposal => @proposal, :for => false)}
    end
    
    it "should count the for votes" do
      @proposal.votes_for.should == 3
    end
    
    it "should count the against votes" do
      @proposal.votes_against.should == 4
    end
  end
  
  describe "#member_count" do
    before(:each) do
      @default_member_class.set_permission!(:vote, true)
    end
    
    it "includes active, inducted members who joined before the proposal was created" do
      @organisation.members.count.should == 1
      
      member_2, member_3, member_4 = @organisation.members.make_n(3, :member_class => @default_member_class)
      
      @proposal = @organisation.proposals.make(:proposer_member_id => @member.id, :title => 'test', :parameters => nil)
      
      @organisation.members.count.should == 4
      @proposal.member_count.should == 4
      
      # Test that newer members aren't included
      member_5 = @organisation.members.make(:member_class => @default_member_class, :created_at => Time.now.utc, :inducted_at => Time.now.utc)
      @organisation.members.count.should == 5
      @proposal.member_count.should == 4
      
      # Test that uninducted members aren't included
      member_2.update_attributes(:inducted_at => nil, :state => 'pending')
      @organisation.members.count.should == 5
      @proposal.member_count.should == 3
    end
    
    it "includes members who were founding members, but who haven't yet been inducted" do
      # Don't want to deal with FoundAssociationProposal validation errors
      ProposalMailer.stub!(:notify_foundation_proposal).and_return(mock('email', :deliver => nil))
      
      member_2, member_3 = @organisation.members.make_n(2, :member_class => @default_member_class, :inducted_at => nil)
      
      fap = @organisation.found_association_proposals.make_unsaved(:proposer_member_id => @member.id)
      # More validation workarounds
      fap.stub!(:association_must_be_ready).and_return(true)
      fap.save!
      
      proposal = @organisation.proposals.make(:proposer_member_id => @member.id)
      proposal.member_count.should == 3
    end
  end
  
  describe "starting" do
    before(:each) do
      @proposer = mock_model(Member)
      @organisation = mock_model(Organisation,
        :pending? => false,
        :constitution => mock("constitution", :voting_period => 3600)
      )

      @proposal = Proposal.new(
        :proposer => @proposer,
        :organisation => @organisation,
        :title => "Buy more tables"
      )
      
      # Stub out ProposalMailerObserver
      @organisation.stub_chain(:members, :active).and_return([])
    end
    
    it "creates a support vote by the proposer" do
      @proposer.should_receive(:cast_vote).with(:for, anything)
      @proposal.save
    end
  end
  
  describe "decision notification message" do
    it "returns nil" do
      Proposal.new.decision_notification_message.should be_nil
    end
  end
end
