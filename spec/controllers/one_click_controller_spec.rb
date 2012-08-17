require 'spec_helper'

module OneClickControllerSpecHelper
  def mock_event
    mock("event").tap do |event|
      event.stub!(:[]).with(:timestamp) do
        rand(5).days.ago
      end
    end
  end
  
  def get_dashboard
    get :dashboard
  end
end

describe OneClickController do
  include OneClickControllerSpecHelper
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
  end
  
  context "when current organisation is a company" do
    before(:each) do
      stub_company
      stub_login
    end
    
    describe "GET dashboard" do
      before(:each) do
        @meeting = mock_model(Meeting)
        Meeting.stub!(:new).and_return(@meeting)
        
        @members_association = mock("members association")
        @company.stub!(:members).and_return(@members_association)
        @member_classes_association = mock("member classes association")
        @company.stub!(:member_classes).and_return(@member_classes_association)
        @director_member_class = mock_model(MemberClass)
        @member_classes_association.stub!(:find_by_name).and_return(@director_member_class)
        @directors = mock("directors")
        @members_association.stub!(:where).and_return(@directors)
        
        @proposals = [
          mock_model(Proposal, :to_event => mock_event),
          mock_model(Proposal, :to_event => mock_event)
        ]
        @meetings = [
          mock_model(Meeting, :to_event => mock_event),
          mock_model(Meeting, :to_event => mock_event)
        ]
        @company.stub_chain(:meetings, :all).and_return(@meetings)
        
        @company.stub(:proposals).and_return(@proposals)
        @company.stub_chain(:decisions, :all).and_return([])
        
        @proposals.stub(:all).and_return(@proposals)
        @proposals.stub!(:currently_open).and_return(@proposals)
        
        @proposals.stub!(:new).and_return(mock_model(Proposal))
      end
      
      it "builds a new meeting" do
        Meeting.should_receive(:new).and_return(@meeting)
        get_dashboard
      end
      
      it "assigns the new meeting" do
        get_dashboard
        assigns(:meeting).should == @meeting
      end
      
      it "finds the directors" do
        @member_classes_association.should_receive(:find_by_name).with('Director').and_return(@director_member_class)
        @members_association.should_receive(:where).with(:member_class_id => @director_member_class.id).and_return(@directors)
        get_dashboard
      end
      
      it "assigns the directors" do
        get_dashboard
        assigns(:directors).should == @directors
      end
      
      describe "timeline" do
        it "assigns the timeline" do
          get_dashboard
          timeline = assigns(:timeline)
          timeline.should respond_to(:each)
          timeline.each do |event|
            event[:timestamp].should be_present
          end
        end
      end
    end
  end
  
  context "when current organisation is an association" do
    before(:each) do
      stub_association
      stub_login
    end
    
    describe "GET dashboard" do
      before(:each) do
        @association.stub_chain(:add_member_proposals, :build).and_return(mock_model(AddMemberProposal))
        @association.stub_chain(:proposals, :currently_open).and_return([])
        @association.stub_chain(:proposals, :new).and_return(mock_model(Proposal))
        @association.stub_chain(:members, :new).and_return(mock_model(Member))
        @association.stub(:default_member_class).and_return(mock_model(MemberClass))
        
        @association.stub_chain(:members, :all).and_return([])
        @association.stub_chain(:proposals, :all).and_return([])
        @association.stub_chain(:decisions, :all).and_return([])
      end
      
      describe "timeline" do
        it "includes Resignation events" do
          @resignation_event = mock('resignation event')
          @association.stub_chain(:resignations, :all).and_return(mock_model(Resignation,
            :to_event => @resignation_event
          ))
          
          get_dashboard
          assigns[:timeline].should include(@resignation_event)
        end
      end
    end
  end

  context "when current organisation is a co-op" do
    before(:each) do
      stub_coop 
      stub_login

      @proposals_association = mock("proposals association")
      @organisation.stub(:proposals).and_return(@proposals_association)

      @proposals_association.stub(:currently_open)
      @proposals_association.stub(:new)

      @organisation.stub_chain(:members, :all).and_return([])
      @organisation.stub_chain(:meetings, :all).and_return([])
      @organisation.stub(:resolutions).and_return([])
      @organisation.stub(:resolution_proposals).and_return([])

      @tasks_association = mock("tasks association")
      @user.stub(:tasks).and_return(@tasks_association)

      @current_tasks_association = mock("current tasks association")
      @tasks_association.stub(:current).and_return(@current_tasks_association)

      @organisation.stub(:active?).and_return(true)
    end

    it "finds the current user's current tasks" do
      @tasks_association.should_receive(:current).and_return(@current_tasks_association)
      get_dashboard
    end

    it "assigns the current user's current tasks" do
      get_dashboard
      assigns[:tasks].should == @current_tasks_association
    end
  end
  
end
