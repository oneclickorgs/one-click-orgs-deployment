require 'spec_helper'

describe MembershipApplicationFormsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login

    controller.stub(:authorize!).with(:update, @organisation)
  end

  describe "GET edit" do
    def get_edit
      get :edit
    end

    it "is successful" do
      get_edit
      response.should be_success
    end
  end

  describe "PUT update" do
    before(:each) do
      @organisation.stub(:membership_application_text=)
      @organisation.stub(:save!)
    end

    def put_update
      put :update, 'organisation' => {'membership_application_text' => 'New custom text.'}
    end

    it "updates the membership application text" do
      @organisation.should_receive(:membership_application_text=).with('New custom text.')
      @organisation.should_receive(:save!)
      put_update
    end

    it "sets a notice flash" do
      put_update
      flash[:notice].should be_present
    end

    it "redirects to the members page" do
      put_update
      response.should redirect_to('/members')
    end
  end

end
