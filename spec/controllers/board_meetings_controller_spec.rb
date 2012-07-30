require 'spec_helper'

describe BoardMeetingsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
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

    it "redirects to the meetings page" do
      post_create
      response.should redirect_to('/meetings')
    end
  end

end
