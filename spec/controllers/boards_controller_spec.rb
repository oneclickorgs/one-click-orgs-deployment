require 'spec_helper'

describe BoardsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET 'show'" do
    let(:board_meetings) {double("board meetings association",
      :upcoming => upcoming_board_meetings,
      :past => past_board_meetings
    )}
    let(:upcoming_board_meetings) {double("upcoming board meetings")}
    let(:past_board_meetings) {double("past board meetings")}
    let(:board_resolutions) {double("board resolutions association",
      :currently_open => open_board_resolutions
    )}
    let(:open_board_resolutions) {double("open board resolutions")}
    let(:user_board_resolutions) {double("user's board resolutions association",
      :draft => draft_resolutions
    )}
    let(:draft_resolutions) {double("current user's draft board resolutions")}

    before(:each) do
      allow(@organisation).to receive(:board_meetings).and_return(board_meetings)
      allow(@organisation).to receive(:board_resolutions).and_return(board_resolutions)
      allow(@user).to receive(:board_resolutions).and_return(user_board_resolutions)
    end

    it "finds the upcoming board meetings" do
      expect(board_meetings).to receive(:upcoming).and_return(upcoming_board_meetings)
      get :show
    end

    it "assigns the upcoming board meetings" do
      get :show
      expect(assigns[:upcoming_meetings]).to eq upcoming_board_meetings
    end

    it "finds open board resolutions" do
      expect(board_resolutions).to receive(:currently_open).and_return(open_board_resolutions)
      get :show
    end

    it "assigns the open board resolutions" do
      get :show
      expect(assigns[:proposals]).to eq(open_board_resolutions)
    end

    it "finds the current user's draft board resolutions" do
      expect(user_board_resolutions).to receive(:draft).and_return(draft_resolutions)
      get :show
    end

    it "assigns the current user's draft board resolutions" do
      get :show
      expect(assigns[:draft_proposals]).to eq(draft_resolutions)
    end

    it "finds the past board meetings" do
      expect(board_meetings).to receive(:past).and_return(past_board_meetings)
      get :show
    end

    it "assigns the past board meetings" do
      get :show
      expect(assigns[:past_meetings]).to eq(past_board_meetings)
    end

    it "returns http success" do
      get 'show'
      expect(response).to be_success
    end
  end

  describe "access control" do
    it "exists"
  end

end
