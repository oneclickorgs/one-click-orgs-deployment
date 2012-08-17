require 'spec_helper'

describe RegistrationFormsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @organisation.stub(:reg_form_timing_factors=)
      @organisation.stub(:reg_form_financial_year_end=)
      @organisation.stub(:reg_form_membership_required=)
      @organisation.stub(:save).and_return(true)
    end

    it "redirects to the edit page" do
      put 'update', 'registration_form' => {}
      response.should redirect_to('/registration_form/edit')
    end
  end

end
