require 'spec_helper'

describe OrganisationsController do
  
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
  end
  
  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

end
