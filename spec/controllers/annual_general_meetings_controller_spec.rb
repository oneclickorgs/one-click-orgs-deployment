require 'spec_helper'

describe AnnualGeneralMeetingsController do

  include ControllerSpecHelper

  let(:annual_general_meetings) {mock("annual_general_meetings",
    :build => annual_general_meeting
  )}
  let(:annual_general_meeting) {mock_model(AnnualGeneralMeeting, :save! => true)}

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login

    @organisation.stub(:annual_general_meetings).and_return(annual_general_meetings)
  end

  describe "GET 'new'" do
    before(:each) do
      @organisation.stub_chain(:resolutions, :draft)
      @organisation.stub(:directors_retiring)
    end

    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "returns http redirect" do
      get 'create'
      response.should be_redirect
    end
  end

  describe "PUT update" do
    let(:annual_general_meetings) {mock("annual_general_meetings association", :find => annual_general_meeting)}
    let(:annual_general_meeting) {mock_model(AnnualGeneralMeeting, :update_attributes => true)}
    let(:annual_general_meeting_attributes) { {'foo' => 'bar'} }

    def put_update
      put :update, 'id' => '1', 'annual_general_meeting' => annual_general_meeting_attributes
    end

    it "finds the AGM" do
      annual_general_meetings.should_receive(:find).with('1').and_return(annual_general_meeting)
      put_update
    end

    it "updates the AGM" do
      annual_general_meeting.should_receive(:update_attributes).with(annual_general_meeting_attributes).and_return(true)
      put_update
    end

    it "redirects to the Meetings page" do
      put_update
      response.should redirect_to('/meetings')
    end

    context "when updating the AGM fails" do
      it "handles the error"
    end
  end

end
