require 'spec_helper'

describe "constitution proposal bundles" do
  
  before(:each) do 
    default_organisation
    default_constitution
    
    @user = login
  end
  
  describe "POST create" do
    before(:each) do
      set_permission!(@user, :constitution_proposal, true)
      @proposal = mock('proposal', :save! => true, :valid? => true)
      
      ChangeTextProposal.stub(:new).and_return(mock('proposal', :save! => true, :valid? => true))
      ChangeVotingSystemProposal.stub(:new).and_return(mock('proposal', :save! => true, :valid? => true))
      ChangeBooleanProposal.stub(:new).and_return(mock('proposal', :save! => true, :valid? => true))
      ChangeVotingPeriodProposal.stub(:new).and_return(mock('proposal', :save! => true, :valid? => true))
    end
    
    def post_create
      post '/constitution_proposal_bundles',
        "constitution_proposal_bundle" => {
          "objectives" => "New objectives",
          "constitution_voting_system" => "Unanimous",
          "assets" => "1",
          "voting_period" => "1209600",
          "organisation_name" => "New name",
          "general_voting_system" => "AbsoluteMajority",
          "membership_voting_system" => "AbsoluteTwoThirdsMajority"
        }
    end
    
    it "should create a proposal to change the organisation name" do
      ChangeTextProposal.should_receive(:new).with(
        :name => 'organisation_name',
        :value => 'New name',
        :proposer => @user
      ).once.ordered.and_return(@proposal)
      @proposal.should_receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to change the objectives" do
      ChangeTextProposal.should_receive(:new).with(
          :name => 'organisation_objectives',
          :value => 'New objectives',
          :proposer => @user
      ).and_return(@proposal)
      @proposal.should_receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to change the general voting system" do
      ChangeVotingSystemProposal.should_receive(:new).with(
        :proposal_type => 'general',
        :proposed_system => 'AbsoluteMajority',
        :proposer => @user
      ).and_return(@proposal)
      @proposal.should_receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to change the membership voting system" do
      ChangeVotingSystemProposal.should_receive(:new).with(
        :proposal_type => 'membership',
        :proposed_system => 'AbsoluteTwoThirdsMajority',
        :proposer => @user
      ).and_return(@proposal)
      @proposal.should_receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to change the constitution voting system" do
      ChangeVotingSystemProposal.should_receive(:new).with(
        :proposal_type => 'constitution',
        :proposed_system => 'Unanimous',
        :proposer => @user
      ).and_return(@proposal)
      @proposal.should_receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to allow assets" do
      ChangeBooleanProposal.should_receive(:new).with(
        :proposer => @user,
        :name => 'assets',
        :value => true,
        :title => "Change the constitution to allow holding, transferral and disposal of material assets and intangible assets"
      ).and_return(@proposal)
      @proposal.should_receive(:save!).and_return(true)
      
      post_create
    end
    
    it "should create a proposal to change the voting period" do
      ChangeVotingPeriodProposal.should_receive(:new).with(
        :new_voting_period => "1209600",
        :proposer => @user
      ).and_return(@proposal)
      @proposal.should_receive(:save!).and_return(true)
      
      post_create
    end
    
    context "when user only changes some of the settings" do
      def post_create
        # Only change objectives and general_voting_system
        post '/constitution_proposal_bundles',
          "constitution_proposal_bundle" => {
            "objectives" => "New objectives",
            "constitution_voting_system" => "AbsoluteTwoThirdsMajority",
            "assets" => "0",
            "voting_period" => "259200",
            "organisation_name" => @organisation.name,
            "general_voting_system" => "AbsoluteMajority",
            "membership_voting_system" => "Veto"
          }
      end
      
      it "should create a proposal to change the objectives" do
        ChangeTextProposal.should_receive(:new).with(
            :name => 'organisation_objectives',
            :value => 'New objectives',
            :proposer => @user
        ).and_return(@proposal)
        @proposal.should_receive(:save!).and_return(true)

        post_create
      end
      
      it "should create a proposal to change the general voting system" do
        ChangeVotingSystemProposal.should_receive(:new).with(
          :proposal_type => 'general',
          :proposed_system => 'AbsoluteMajority',
          :proposer => @user
        ).and_return(@proposal)
        @proposal.should_receive(:save!).and_return(true)

        post_create
      end
      
      it "should not create a proposal to change the organisation name" do
        ChangeTextProposal.should_not_receive(:new).with(hash_including(
          :name => 'organisation_name'
        ))

        post_create
      end
      
      it "should not create a proposal to change the membership voting system" do
        ChangeVotingSystemProposal.should_not_receive(:new).with(hash_including(
          :proposal_type => 'membership',
          :proposed_system => 'AbsoluteTwoThirdsMajority'
        ))
        
        post_create
      end

      it "should create a proposal to change the constitution voting system" do
        ChangeVotingSystemProposal.should_not_receive(:new).with(hash_including(
          :proposal_type => 'constitution',
          :proposed_system => 'Unanimous'
        ))

        post_create
      end

      it "should create a proposal to allow assets" do
        ChangeBooleanProposal.should_not_receive(:new).with(hash_including(
          :name => 'assets'
        ))

        post_create
      end

      it "should not create a proposal to change the voting period" do
        ChangeVotingPeriodProposal.should_not_receive(:new)

        post_create
      end
    end
    
    context "when user does not have permission to create constitutional proposals" do
      before(:each) do
        set_permission!(@user, :constitution_proposal, false)
      end
      
      it "redirects" do
        post_create
        response.should be_redirect
      end
      
      it "sets an error flash" do
        post_create
        flash[:error].should be_present
      end
      
      it "does not create any proposals" do
        ChangeTextProposal.should_not_receive(:new)
        ChangeBooleanProposal.should_not_receive(:new)
        ChangeVotingPeriodProposal.should_not_receive(:new)
        ChangeVotingSystemProposal.should_not_receive(:new)
        post_create
      end
    end
  end
  
end
