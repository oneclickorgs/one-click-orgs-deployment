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

end
