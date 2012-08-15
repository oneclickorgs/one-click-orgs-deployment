require 'spec_helper'

describe ShareApplicationsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET new" do
    let(:share_application) {mock_model(ShareApplication).as_new_record}

    before(:each) do
      ShareApplication.stub(:new).and_return(share_application)
    end

    def get_new
      get :new
    end

    it "builds a share transaction" do
      ShareApplication.should_receive(:new).and_return(share_application)
      get_new
    end

    it "assigns the share transaction" do
      get_new
      assigns[:share_application].should == share_application
    end

    it "is successful" do
      get_new
      response.should be_success
    end
  end

  describe "POST create" do
    let(:share_application_params) {{'amount' => '5'}}
    let(:share_application) {mock_model(ShareApplication,
      :member= => nil,
      :save! => true
    ).as_new_record}

    before(:each) do
      ShareApplication.stub(:new).and_return(share_application)
    end

    def post_create
      post :create, 'share_application' => share_application_params
    end

    it "builds the share application" do
      ShareApplication.should_receive(:new).with(share_application_params).and_return(share_application)
      post_create
    end

    it "assigns the current user" do
      share_application.should_receive(:member=).with(@user)
      post_create
    end

    it "saves the share application" do
      share_application.should_receive(:save!)
      post_create
    end

    it "redirects to the shares page" do
      post_create
      response.should redirect_to('/shares')
    end
  end

end
