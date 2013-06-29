require 'spec_helper'

describe OrganisationsController do
  
  include ControllerSpecHelper
  
  before(:each) do
    stub_app_setup
  end
  
  describe "GET 'new'" do
    before(:each) do
      Setting.stub(:[]).with(:theme).and_return(nil)
    end

    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

end
