require 'spec_helper'

describe RegistrationFormsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET 'edit'" do
    let(:founder_members) {mock("founder members association")}

    before(:each) do
      @organisation.stub(:founder_members).and_return(founder_members)
    end

    def get_edit
      get :edit
    end

    it "finds the founder members" do
      @organisation.should_receive(:founder_members)
      get_edit
    end

    it "assigns the founder members" do
      get_edit
      assigns[:founder_members].should == founder_members
    end

    it "returns http success" do
      get_edit
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    let(:reg_form_signatories_attributes) {"reg_form_signatories_attributes"}

    before(:each) do
      @organisation.stub(:reg_form_timing_factors=)
      @organisation.stub(:reg_form_financial_year_end=)
      @organisation.stub(:reg_form_close_links=)
      @organisation.stub(:reg_form_signatories_attributes=)
      @organisation.stub(:save).and_return(true)
    end

    def put_update
      put 'update', 'registration_form' => {'reg_form_signatories_attributes' => reg_form_signatories_attributes}
    end

    it "updates the reg_form_signatories_attributes attribute" do
      @organisation.should_receive(:reg_form_signatories_attributes=).with(reg_form_signatories_attributes)
      put_update
    end

    it "redirects to the edit page" do
      put_update
      response.should redirect_to('/registration_form/edit')
    end
  end

end
