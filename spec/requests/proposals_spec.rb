require 'spec_helper'

module ProposalsSpecHelper
  def a_proposal_exists
    Proposal.destroy_all
    user = login
    
    set_permission!(user, :freeform_proposal, true)
    post(proposals_path, {:proposal => {:id => nil, :proposer_member_id => user.id, :title => 'proposal'}})
    @proposal = Proposal.first or raise "can't create a proposal"
  end
end

describe "Proposals" do
  include ProposalsSpecHelper
  
  before(:each) do 
    stub_organisation!
    stub_constitution!
    
    @user = login
  end
  
  describe "/proposals/1, given a proposal exists" do
    before(:each) do
      set_permission!(@user, :vote, true)
      @member_two = @organisation.members.make(:member_class => @default_member_class)
      set_permission!(@member_two, :vote, true)
      @member_three = @organisation.members.make(:member_class => @default_member_class)
      set_permission!(@member_two, :vote, true)
      
      a_proposal_exists
    end
    
    describe "GET" do
      before(:each) do
        @proposal = Proposal.first
        @member_two.cast_vote(:for, @proposal.id)
        @member_three.cast_vote(:against, @proposal.id)

        get(proposal_path(@proposal))
      end
  
      it "responds successfully" do
        @response.should be_successful
      end
    end
  end
  
  describe "/proposals, given a proposal exists"  do
    before(:each) do
      a_proposal_exists
    end
    
     describe "GET" do
       before(:each) do
         get(proposals_path)
       end

       it "responds successfully" do
         @response.should be_successful
       end

       it "contains a list of proposals" do
         # pending
         @response.should have_xpath("//ul")
       end
     end
  end
  
  describe "creating settings proposals in bulk" do
    let(:change_text_proposals_association) {mock('change_text_proposals association')}
    let(:change_voting_system_proposals_association) {mock('change_voting_system_proposals association')}
    let(:change_boolean_proposals_association) {mock('change_boolean_proposals association')}
    let(:change_voting_period_proposals_association) {mock('change_voting_period_proposals association')}

    before(:each) do
      @user = login
      set_permission!(@user, :constitution_proposal, true)
      @proposal = mock('proposal', :save => true, :start => true, :accepted? => false)

      @organisation.stub(:change_text_proposals).and_return(change_text_proposals_association)
      @organisation.stub(:change_voting_system_proposals).and_return(change_voting_system_proposals_association)
      @organisation.stub(:change_boolean_proposals).and_return(change_boolean_proposals_association)
      @organisation.stub(:change_voting_period_proposals).and_return(change_voting_period_proposals_association)
      
      change_text_proposals_association.stub(:new).and_return(mock('proposal', :save => true, :start => true, :accepted? => false))
      change_voting_system_proposals_association.stub(:new).and_return(mock('proposal', :save => true, :start => true, :accepted? => false))
      change_boolean_proposals_association.stub(:new).and_return(mock('proposal', :save => true, :start => true, :accepted? => false))
      change_voting_period_proposals_association.stub(:new).and_return(mock('proposal', :save => true, :start => true, :accepted? => false))
    end
    
    def post_create_settings_proposals
      post '/proposals/create_settings_proposals', {"organisation_objectives"=>"New objectives", "constitution_voting_system"=>"Unanimous", "assets"=>"1", "voting_period"=>"1209600", "organisation_name"=>"New name", "general_voting_system"=>"AbsoluteMajority", "membership_voting_system"=>"AbsoluteTwoThirdsMajority"}
    end
    
    it "should create a proposal to change the organisation name" do
      change_text_proposals_association.should_receive(:new).with(
        :parameters => {
          'name' => 'organisation_name',
          'value' => 'New name'
        },
        :proposer_member_id => @user.id,
        :title => "Change organisation name to 'New name'"
      ).once.ordered.and_return(@proposal)
      @proposal.should_receive(:start).and_return(true)
      @proposal.should_receive(:accepted?).and_return(false)
      
      post_create_settings_proposals
    end
    
    it "should create a proposal to change the objectives" do
      change_text_proposals_association.should_receive(:new).with(
        :parameters => {
          'name' => 'organisation_objectives',
          'value' => 'New objectives'
        },
        :proposer_member_id => @user.id,
        :title => "Change organisation objectives to 'New objectives'"
      ).and_return(@proposal)
      @proposal.should_receive(:start).and_return(true)
      @proposal.should_receive(:accepted?).and_return(false)
      
      post_create_settings_proposals
    end
    
    it "should create a proposal to change the general voting system" do
      change_voting_system_proposals_association.should_receive(:new).with(
        :parameters => {
          'type' => 'general',
          'proposed_system' => 'AbsoluteMajority'
        },
        :proposer_member_id => @user.id,
        :title => "Change general voting system to Absolute majority: decisions need supporting votes from more than 50% of members"
      ).and_return(@proposal)
      @proposal.should_receive(:start).and_return(true)
      @proposal.should_receive(:accepted?).and_return(false)
      
      post_create_settings_proposals
    end
    
    it "should create a proposal to change the membership voting system" do
      change_voting_system_proposals_association.should_receive(:new).with(
        :parameters => {
          'type' => 'membership',
          'proposed_system' => 'AbsoluteTwoThirdsMajority'
        },
        :proposer_member_id => @user.id,
        :title => "Change membership voting system to Two thirds majority: decisions need supporting votes from more than 66% of members"
      ).and_return(@proposal)
      @proposal.should_receive(:start).and_return(true)
      @proposal.should_receive(:accepted?).and_return(false)
      
      post_create_settings_proposals
    end
    
    it "should create a proposal to change the constitution voting system" do
      change_voting_system_proposals_association.should_receive(:new).with(
        :parameters => {
          'type' => 'constitution',
          'proposed_system' => 'Unanimous'
        },
        :proposer_member_id => @user.id,
        :title => "Change constitution voting system to Unanimous: decisions need supporting votes from 100% of members"
      ).and_return(@proposal)
      @proposal.should_receive(:start).and_return(true)
      @proposal.should_receive(:accepted?).and_return(false)
      
      post_create_settings_proposals
    end
    
    it "should create a proposal to allow assets" do
      change_boolean_proposals_association.should_receive(:new).with(
        :proposer_member_id => @user.id,
        :parameters => {
          'name' => 'assets',
          'value' => true
        },
        :title => "Change the constitution to allow holding, transferral and disposal of material assets and intangible assets"
      ).and_return(@proposal)
      @proposal.should_receive(:start).and_return(true)
      @proposal.should_receive(:accepted?).and_return(false)
      
      post_create_settings_proposals
    end
    
    it "should create a proposal to change the voting period" do
      change_voting_period_proposals_association.should_receive(:new).with(
        :title => "Change voting period to 14 days",
        :parameters => {
          'new_voting_period' => "1209600"
        },
        :proposer_member_id => @user.id
      ).and_return(@proposal)
      @proposal.should_receive(:start).and_return(true)
      @proposal.should_receive(:accepted?).and_return(false)
      
      post_create_settings_proposals
    end
  end
  
  describe "proposing text amendments" do
    let(:change_text_proposals_association) {mock('change_text_proposals association')}

    before(:each) do
      @user = login
      set_permission!(@user, :constitution_proposal, true)
      @proposal = mock('proposal', :save => true)
      @organisation.stub(:change_text_proposals).and_return(change_text_proposals_association)
    end
    
    it "should create a proposal to change the organisation name" do
      change_text_proposals_association.should_receive(:new).with(
        :title => "Change name to 'The Yoghurt Yurt'",
        :parameters => {
          'name' => 'name',
          'value' => 'The Yoghurt Yurt'
        },
        :proposer_member_id => @user.id
      ).and_return(@proposal)
      @proposal.should_receive(:start).and_return(true)
      @proposal.should_receive(:accepted?).and_return(false)
      
      post(url_for(:controller => 'proposals', :action => 'create_text_amendment'), {'name' => 'name', 'value' => 'The Yoghurt Yurt'})

      @response.should redirect_to('/one_click/dashboard')
    end
    
    it "should create a proposal to change the objectives" do
      change_text_proposals_association.should_receive(:new).with(
        :title => "Change objectives to 'make all the yoghurt'",
        :parameters => {
          'name' => 'objectives',
          'value' => 'make all the yoghurt'
        },
        :proposer_member_id => @user.id
      ).and_return(@proposal)
      @proposal.should_receive(:start).and_return(true)
      @proposal.should_receive(:accepted?).and_return(false)
      
      post(url_for(:controller => 'proposals', :action => 'create_text_amendment'), {'name' => 'objectives', 'value' => 'make all the yoghurt'})
      
      @response.should redirect_to('/one_click/dashboard')
    end
    
    it "should create a proposal to change the domain" do
      change_text_proposals_association.should_receive(:new).with(
        :title => "Change domain to 'yaourt.com'",
        :parameters => {
          'name' => 'domain',
          'value' => 'yaourt.com'
        },
        :proposer_member_id => @user.id
      ).and_return(@proposal)
      @proposal.should_receive(:start).and_return(true)
      @proposal.should_receive(:accepted?).and_return(false)
      
      post(url_for(:controller => 'proposals', :action => 'create_text_amendment'), {'name' => 'domain', 'value' => 'yaourt.com'})
      
      @response.should redirect_to('/one_click/dashboard')
    end
  end
  
  describe "proposing text amendments without having permission" do
    before(:each) do
      @user = login
      set_permission!(@user, :constitution_proposal, false)
    end
    
    it "should fail" do      
      post(url_for(:controller => 'proposals', :action => 'create_text_amendment'), {'name' => 'name', 'value' => 'The Yoghurt Yurt'})
      @response.should redirect_to('/')
      Proposal.where(:proposer_member_id => @user.id).should be_empty
    end
  end
  
  describe "proposing voting system amendments" do
    before do
      login
      set_permission!(@user, :constitution_proposal, true)
      @general_voting_system = @organisation.clauses.set_text!('general_voting_system', 'RelativeMajority')
      @membership_voting_system = @organisation.clauses.set_text!('membership_voting_system', 'RelativeMajority')
      @constitution_voting_system = @organisation.clauses.set_text!('constitution_voting_system', 'RelativeMajority')
    end
    
    describe "for general decisions" do
      it "should add the proposal" do
        post(url_for(:controller => 'proposals', :action => 'create_voting_system_amendment'), {:general_voting_system => 'Unanimous'})

        puts @response.body if @response.status != 302

        @response.should redirect_to("/one_click/dashboard")
      
        ChangeVotingSystemProposal.count.should == 1
        ChangeVotingSystemProposal.first.title.should == 'Change general voting system to Unanimous: decisions need supporting votes from 100% of members'
        proposal_parameters = ChangeVotingSystemProposal.all.first.parameters
        proposal_parameters['type'].should == 'general'
        proposal_parameters['proposed_system'].should == 'Unanimous'
      end
    end
    
    describe "for membership decisions" do
      it "should add the proposal" do
        post(url_for(:controller=>'proposals', :action=>'create_voting_system_amendment'), {:membership_voting_system=>'Veto'})

        puts @response.body if @response.status != 302

        @response.should redirect_to("/one_click/dashboard")
      
        ChangeVotingSystemProposal.count.should == 1
        ChangeVotingSystemProposal.all.first.title.should == 'Change membership voting system to Nobody opposes: decisions blocked if there are any opposing votes'
        proposal_parameters = ChangeVotingSystemProposal.all.first.parameters
        proposal_parameters['type'].should == 'membership'
        proposal_parameters['proposed_system'].should == 'Veto'
      end
    end
    
    describe "for constitution decisions" do
      it "should add the proposal" do
        post(url_for(:controller=>'proposals', :action=>'create_voting_system_amendment'), {:constitution_voting_system=>'AbsoluteMajority'})

        puts @response.body if @response.status == 500
        @response.should redirect_to("/one_click/dashboard")
      
        ChangeVotingSystemProposal.count.should == 1
        ChangeVotingSystemProposal.all.first.title.should == 'Change constitution voting system to Absolute majority: decisions need supporting votes from more than 50% of members'
        proposal_parameters = ChangeVotingSystemProposal.all.first.parameters
        proposal_parameters['type'].should == 'constitution'
        proposal_parameters['proposed_system'].should == 'AbsoluteMajority'
      end
    end
    
    describe "voting period amendments" do
      it "should add the proposal" do
        post(url_for(:controller=>'proposals', :action=>'create_voting_period_amendment'), {:new_voting_period=>'86400'})

        puts @response.body if @response.status == 500
        @response.should redirect_to("/one_click/dashboard")

        ChangeVotingPeriodProposal.count.should == 1
        ChangeVotingPeriodProposal.all.first.title.should == 'Change voting period to 1 day'
        proposal_parameters = ChangeVotingPeriodProposal.all.first.parameters
        proposal_parameters['new_voting_period'].to_i.should == 86400
      end
    end
  end
  
  describe "proposing voting system amendments without having permission" do
    before(:each) do
      @user = login
      set_permission!(@user, :constitution_proposal, false)
    end
    
    it "should fail" do      
      post(url_for(:controller => 'proposals', :action => 'create_voting_period_amendment'), {:new_voting_period=>'666'})
      @response.should redirect_to('/')
      Proposal.where(:proposer_member_id => @user.id).should be_empty
    end
  end
  
  describe "proposing the founding of the organisation" do
    before(:each) do
      @user = login
      set_permission!(@user, :found_organisation_proposal, true)
      
      # Need at least three members to propose foundation
      @organisation.members.make_n(2)
      
      @organisation.pending!
    end
    
    it "should add the proposal" do
      post(url_for(:controller => 'proposals', :action => 'propose_foundation'))
      
      # follow_redirect!
      # raise @response.body
      
      FoundOrganisationProposal.count.should == 1
      FoundOrganisationProposal.first.title.should =~ /test/ # The name of the org
      FoundOrganisationProposal.first.description.should be_present
    end
  end
end
