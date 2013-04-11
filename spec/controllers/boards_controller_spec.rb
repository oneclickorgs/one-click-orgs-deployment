require 'spec_helper'

describe BoardsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET 'show'" do
    let(:board_meetings) {mock("board meetings association",
      :upcoming => upcoming_board_meetings,
      :past => past_board_meetings
    )}
    let(:upcoming_board_meetings) {mock("upcoming board meetings")}
    let(:past_board_meetings) {mock("past board meetings")}
    let(:board_resolutions) {mock("board resolutions association",
      :currently_open => open_board_resolutions
    )}
    let(:open_board_resolutions) {mock("open board resolutions")}
    let(:user_board_resolutions) {mock("user's board resolutions association",
      :draft => draft_resolutions
    )}
    let(:draft_resolutions) {mock("current user's draft board resolutions")}

    before(:each) do
      @organisation.stub(:board_meetings).and_return(board_meetings)
      @organisation.stub(:board_resolutions).and_return(board_resolutions)
      @user.stub(:board_resolutions).and_return(user_board_resolutions)
    end

    it "finds the upcoming board meetings" do
      board_meetings.should_receive(:upcoming).and_return(upcoming_board_meetings)
      get :show
    end

    it "assigns the upcoming board meetings" do
      get :show
      assigns[:upcoming_meetings].should eq upcoming_board_meetings
    end

    it "finds open board resolutions" do
      board_resolutions.should_receive(:currently_open).and_return(open_board_resolutions)
      get :show
    end

    it "assigns the open board resolutions" do
      get :show
      assigns[:proposals].should == open_board_resolutions
    end

    it "finds the current user's draft board resolutions" do
      user_board_resolutions.should_receive(:draft).and_return(draft_resolutions)
      get :show
    end

    it "assigns the current user's draft board resolutions" do
      get :show
      assigns[:draft_proposals].should == draft_resolutions
    end

    it "finds the past board meetings" do
      board_meetings.should_receive(:past).and_return(past_board_meetings)
      get :show
    end

    it "assigns the past board meetings" do
      get :show
      assigns[:past_meetings].should == past_board_meetings
    end

    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "access control" do
    it "exists"
  end

end
