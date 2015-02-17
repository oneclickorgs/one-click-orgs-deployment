require 'rails_helper'

describe MinutesController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET new" do
    let(:minute) {mock_model(Minute).as_new_record}
    let(:members) {double("members association", :map => nil)}

    before(:each) do
      allow(@organisation).to receive(:build_minute).and_return(minute)
      allow(@organisation).to receive(:meeting_classes).and_return([GeneralMeeting, AnnualGeneralMeeting, BoardMeeting])
      allow(@organisation).to receive(:members).and_return(members)
    end

    def get_new
      get :new
    end

    it "builds a new minute" do
      expect(@organisation).to receive(:build_minute).and_return(minute)
      get_new
    end

    it "assigns the new minute" do
      get_new
      expect(assigns[:minute]).to eq(minute)
    end

    it "builds a collection of minute class options for a select" do
      expect(@organisation).to receive(:meeting_classes).and_return([GeneralMeeting, AnnualGeneralMeeting, BoardMeeting])
      get_new
    end

    it "assigns the collection of minute class options" do
      get_new
      expect(assigns[:meeting_class_options_for_select]).to eq([
        ['General Meeting', 'GeneralMeeting'],
        ['Annual General Meeting', 'AnnualGeneralMeeting'],
        ['Board Meeting', 'BoardMeeting']
      ])
    end

    it "looks up the members" do
      expect(@organisation).to receive(:members).and_return(members)
      get_new
    end

    it "assigns the members" do
      get_new
      expect(assigns[:members]).to eq(members)
    end

    it "is successful" do
      get_new
      expect(response).to be_success
    end
  end

  describe "POST create" do
    let(:minute_params) {{'minutes' => 'Something'}}
    let(:minute) {mock_model(Minute, :save => true).as_new_record}

    before(:each) do
      allow(@organisation).to receive(:build_minute).and_return(minute)
    end

    def post_create
      post :create, 'minute' => minute_params
    end

    it "builds the minute" do
      expect(@organisation).to receive(:build_minute).with(minute_params).and_return(minute)
      post_create
    end

    it "saves the minute" do
      expect(minute).to receive(:save)
      post_create
    end

    it "redirects to the meetings page" do
      post_create
      expect(response).to redirect_to('/meetings')
    end
  end

end
