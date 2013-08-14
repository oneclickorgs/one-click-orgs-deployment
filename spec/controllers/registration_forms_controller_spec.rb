require 'spec_helper'

describe RegistrationFormsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET 'edit'" do
    let(:members) {double("members association")}

    before(:each) do
      @organisation.stub(:members_with_signatories_selected).and_return(members)
    end

    def get_edit
      get :edit
    end

    it "finds the members" do
      @organisation.should_receive(:members_with_signatories_selected)
      get_edit
    end

    it "assigns the members" do
      get_edit
      assigns[:members].should == members
    end

    it "returns http success" do
      get_edit
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    let(:registration_form_attributes) {"registration_form attributes"}

    before(:each) do
      @organisation.stub(:attributes=)
      @organisation.stub(:save).and_return(true)
    end

    def put_update
      put 'update', 'registration_form' => registration_form_attributes
    end

    it "updates the registration form attributes" do
      expect(@organisation).to receive(:attributes=).with(registration_form_attributes)
      put_update
    end

    it "saves the registration form" do
      expect(@organisation).to receive(:save).and_return(true)
      put_update
    end


    it "redirects to the edit page" do
      put_update
      response.should redirect_to('/registration_form/edit')
    end
  end

end
