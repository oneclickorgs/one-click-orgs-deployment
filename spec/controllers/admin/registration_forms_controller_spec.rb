require 'rails_helper'

describe Admin::RegistrationFormsController do

  include ControllerSpecHelper

  let(:organisation) {mock_model(Coop, :to_param => '111')}

  before(:each) do
    stub_app_setup
    stub_administrator_login

    allow(Organisation).to receive(:find).and_return(organisation)
  end

  describe "GET edit" do
    before(:each) do
      allow(organisation).to receive(:members_with_signatories_selected)
    end

    def get_edit
      get :edit, :id => 111
    end

    it "is successful" do
      get_edit
      expect(response).to be_success
    end
  end

  describe "PUT update" do
    let(:registration_form_attributes) {{}}

    before(:each) do
      allow(organisation).to receive(:attributes=)
      allow(organisation).to receive(:save).and_return(true)
    end

    def put_update
      put :update, :id => 111, :registration_form => registration_form_attributes
    end

    it "updates the registration form" do
      expect(organisation).to receive(:attributes=).with(registration_form_attributes)
      put_update
    end

    it "saves the registration form" do
      expect(organisation).to receive(:save).and_return(true)
      put_update
    end

    it "redirects to admin/coops/show" do
      put_update
      expect(response).to redirect_to('/admin/coops/111')
    end
  end

end
