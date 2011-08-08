require 'spec_helper'

module OneClickControllerSpecHelper
  def mock_event
    mock("event").tap do |event|
      event.stub!(:[]).with(:timestamp) do
        rand(5).days.ago
      end
    end
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
        @proposals.stub(:all).and_return(@proposals)
        @proposals.stub!(:currently_open).and_return(@proposals)
        
        @proposals.stub!(:new).and_return(mock_model(Proposal))
      end
      
      def get_dashboard
        get :dashboard
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
