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
      
      @comments_association = double("comments association")
      @meeting.stub(:comments).and_return(@comments_association)
      
      @comment = mock_model(Comment).as_new_record
      Comment.stub(:new).and_return(@comment)
      
      controller.stub(:can?).with(:read, @meeting).and_return(true)
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
    
    it "assigns the meeting's comments" do
      get_show
      assigns(:comments).should == @comments_association
    end
    
    it "builds a new comment" do
      Comment.should_receive(:new).and_return(@comment)
      get_show
    end
    
    it "assigns the new comment" do
      get_show
      assigns(:comment).should == @comment
    end
    
    it "renders the meetings/show template" do
      get_show
      response.should render_template('meetings/show')
    end
    
    context "when user is not permitted to view the meeting" do
      before(:each) do
        controller.stub(:can?).with(:read, @meeting).and_return(false)
      end
      
      it "redirects to the dashboard" do
        get_show
        response.should redirect_to root_path
      end
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
      
      @meeting = mock_model(Meeting, :creator= => nil).as_new_record
      @meetings_association.stub(:build).and_return(@meeting)
      
      @meeting.stub(:attributes=)
      @meeting.stub(:save).and_return(true)
      
      controller.stub(:can?).with(:create, Meeting).and_return(true)
    end
    
    def post_create
      post :create, 'meeting' => @meeting_parameters
    end
    
    it "builds the new meeting without setting attributes" do
      # This is to avoid trying to set the participants before
      # setting the organisation, since Meeting has to validate
      # the participants' membership of the organisation.
      @meetings_association.should_receive(:build).with().and_return(@meeting)
      post_create
    end
    
    it "sets the meeting's attributes" do
      @meeting.should_receive(:attributes=).with(@meeting_parameters)
      post_create
    end
    
    it "saves the meeting" do
      @meeting.should_receive(:save).and_return(true)
      post_create
    end
    
    it "logs that the current user created the meeting" do
      @meeting.should_receive(:creator=).with(@user)
      post_create
    end
    
    it "redirects to the dashboard" do
      post_create
      response.should redirect_to '/'
    end
    
    context "when saving the meeting fails" do
      before(:each) do
        @meeting.stub(:save).and_return(false)
        
        @member_classes_association = double("member classes association")
        @company.stub(:member_classes).and_return(@member_classes_association)
        
        @director_member_class = mock_model(Director)
        @member_classes_association.stub(:find_by_name).and_return(@director_member_class)
        
        @members_association = double("members association")
        @company.stub(:members).and_return(@members_association)
        
        @directors = double("directors")
        @members_association.stub(:where).and_return(@directors)
      end
      
      it "finds the directors" do
        @member_classes_association.should_receive(:find_by_name).with('Director').and_return(@director_member_class)
        @members_association.should_receive(:where).with(:member_class_id => @director_member_class.id).and_return(@directors)
        post_create
      end
      
      it "assigns the directors" do
        post_create
        assigns(:directors).should == @directors
      end
      
      it "renders the 'new' template" do
        post_create
        response.should render_template 'meetings/new'
      end
      
      it "sets an error flash" do
        post_create
        flash[:error].should be_present
      end
    end
    
    context "when the user is not permitted to create a meeting" do
      before(:each) do
        controller.stub(:can?).with(:create, Meeting).and_return(false)
      end
      
      it "does not save the meeting" do
        @meeting.should_not_receive(:save)
        post_create
      end
    end
  end
  
end
