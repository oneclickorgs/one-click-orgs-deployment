require 'spec_helper'

describe BoardsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET 'show'" do
    let(:board_meetings) {mock("board meetings association", :upcoming => upcoming_board_meetings)}
    let(:upcoming_board_meetings) {mock("upcoming board meetings")}

    before(:each) do
      @organisation.stub(:board_meetings).and_return(board_meetings)
    end

    it "finds the upcoming board meetings" do
      board_meetings.should_receive(:upcoming).and_return(upcoming_board_meetings)
      get :show
    end

    it "assigns the upcoming board meetings" do
      get :show
      assigns[:upcoming_meetings].should eq upcoming_board_meetings
    end

    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

end
