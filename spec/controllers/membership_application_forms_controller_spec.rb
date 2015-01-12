require 'spec_helper'

describe MembershipApplicationFormsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login

    allow(controller).to receive(:authorize!).with(:update, @organisation)
  end

  describe "GET edit" do
    def get_edit
      get :edit
    end

    it "is successful" do
      get_edit
      expect(response).to be_success
    end
  end

  describe "PUT update" do
    before(:each) do
      allow(@organisation).to receive(:membership_application_text=)
      allow(@organisation).to receive(:save!)
    end

    def put_update
      put :update, 'organisation' => {'membership_application_text' => 'New custom text.'}
    end

    it "updates the membership application text" do
      expect(@organisation).to receive(:membership_application_text=).with('New custom text.')
      expect(@organisation).to receive(:save!)
      put_update
    end

    it "sets a notice flash" do
      put_update
      expect(flash[:notice]).to be_present
    end

    it "redirects to the members page" do
      put_update
      expect(response).to redirect_to('/members')
    end
  end

end
