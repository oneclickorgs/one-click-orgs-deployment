require 'spec_helper'

describe MeetingsController do
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
    stub_company
    stub_login
  end
  
  describe "GET show" do
    before(:each) do
      @meeting = mock_model(Meeting)
      
      @meetings_association = double("meetings association")
      @meetings_association.stub(:find).and_return(@meeting)
      
      @company.stub(:meetings).and_return(@meetings_association)
    end
    
    def get_show
      get :show, :id => '1'
    end
    
    it "finds the meeting" do
      @meetings_association.should_receive(:find).with('1').and_return(@meeting)
      get_show
    end
    
    it "assigns the meeting" do
      get_show
      assigns(:meeting).should == @meeting
    end
    
    it "renders the meetings/show template" do
      get_show
      response.should render_template('meetings/show')
    end
  end
  
  describe "POST create" do
    before(:each) do
      @meeting_parameters = {
        "happened_on(1i)" => "2011",
        "happened_on(2i)" => "5",
        "happened_on(3i)" => "1",
        "participant_ids" => {"1001" => "1", "1002" => "1"},
        "minutes" => "Preferred coffee suppliers."
      }
      
      @meetings_association = double("meetings association")
      @company.stub(:meetings).and_return(@meetings_association)
      
      @meeting = mock_model(Meeting).as_new_record
      @meetings_association.stub(:build).and_return(@meeting)
      
      @meeting.stub!(:save).and_return(true)
    end
    
    def post_create
      post :create, 'meeting' => @meeting_parameters
    end
    
    it "builds the new meeting" do
      @meetings_association.should_receive(:build).with(@meeting_parameters).and_return(@meeting)
      post_create
    end
    
    it "saves the meeting" do
      @meeting.should_receive(:save).and_return(true)
      post_create
    end
    
    it "logs that the current user created the meeting"
    
    it "redirects to the dashboard" do
      post_create
      response.should redirect_to '/'
    end
    
    context "when saving the meeting fails" do
      it "handles the error gracefully"
    end
  end
  
end
