require 'spec_helper'

describe BoardMeetingsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET show" do
    let(:board_meeting) {mock_model(BoardMeeting)}
    let(:board_meetings) {mock("board meetings", :find => board_meeting)}

    before(:each) do
      @organisation.stub(:board_meetings).and_return(board_meetings)
    end

    def get_show
      get :show, :id => '1'
    end

    it "finds the board meeting" do
      board_meetings.should_receive(:find).with('1').and_return(board_meeting)
      get_show
    end

    it "assigns the board meeting" do
      get_show
      assigns[:board_meeting].should == board_meeting
    end

    it "is successful" do
      get_show
      response.should be_success
    end
  end

  describe "GET new" do
    before(:each) do
      @board_meeting = mock_model(BoardMeeting).as_new_record
      @board_meetings_association = mock("board meetings association")

      @organisation.stub(:board_meetings).and_return(@board_meetings_association)
      @board_meetings_association.stub(:build).and_return(@board_meeting)
    end

    def get_new
      get :new
    end

    it "builds a new board meeting" do
      @board_meetings_association.should_receive(:build).and_return(@board_meeting)
      get_new
    end

    it "assigns the board meeting" do
      get_new
      assigns[:board_meeting].should == @board_meeting
    end

    it "is successful" do
      get_new
      response.should be_success
    end
  end

  describe "POST create" do
    before(:each) do
      @board_meetings_association = mock("board meetings association")
      @board_meeting_params = {'venue' => 'The Meeting Hall'}
      @board_meeting = mock_model(BoardMeeting,
        :creator= => nil,
        :save! => nil
      ).as_new_record

      @organisation.stub(:board_meetings).and_return(@board_meetings_association)
      @board_meetings_association.stub(:build).and_return(@board_meeting)
    end

    def post_create
      post :create, 'board_meeting' => @board_meeting_params
    end

    it "builds the board meeting" do
      @board_meetings_association.should_receive(:build).with(@board_meeting_params).and_return(@board_meeting)
      post_create
    end

    it "assigns the creator to the current user" do
      @board_meeting.should_receive(:creator=).with(@user)
      post_create
    end

    it "saves the board meeting" do
      @board_meeting.should_receive(:save!)
      post_create
    end

    it "redirects to the Board page" do
      post_create
      response.should redirect_to('/board')
    end
  end

  describe "GET edit" do
    let(:board_meeting) {mock_model(BoardMeeting)}
    let(:board_meetings) {mock("board meetings association",
      :find => board_meeting
    )}
    let(:directors) {mock("directors")}

    before(:each) do
      @organisation.stub(:board_meetings).and_return(board_meetings)
      @organisation.stub(:directors).and_return(directors)
    end

    def get_edit
      get :edit, :id => '1'
    end

    it "finds the board meeting" do
      board_meetings.should_receive(:find).with('1').and_return(board_meeting)
      get_edit
    end

    it "assigns the board meeting" do
      get_edit
      assigns[:board_meeting].should == board_meeting
    end

    it "finds the directors" do
      @organisation.should_receive(:directors).and_return(directors)
      get_edit
    end

    it "assigns the directors" do
      get_edit
      assigns(:directors).should == directors
    end

    it "is successful" do
      get_edit
      response.should be_success
    end
  end

  describe "PUT update" do
    let(:board_meeting) {mock_model(BoardMeeting, :update_attributes => true)}
    let(:board_meetings) {mock("board meetings", :find => board_meeting)}
    let(:board_meeting_attributes) {{'foo' => 'bar'}}

    before(:each) do
      @organisation.stub(:board_meetings).and_return(board_meetings)
    end

    def put_update
      put :update, :id => '1', 'board_meeting' => board_meeting_attributes
    end

    it "finds the board meeting" do
      board_meetings.should_receive(:find).with('1').and_return(board_meeting)
      put_update
    end

    it "updates the board meeting" do
      board_meeting.should_receive(:update_attributes).with(board_meeting_attributes).and_return(true)
      put_update
    end

    it "redirects to the board index" do
      put_update
      response.should redirect_to('/board')
    end

    context "when updating the board meeting fails" do
      it "handles the error"
    end
  end

end
