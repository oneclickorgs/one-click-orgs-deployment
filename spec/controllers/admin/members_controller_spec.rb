require 'spec_helper'

describe Admin::MembersController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_administrator_login
  end

  describe "GET edit" do
    let (:member) {mock_model(Member)}

    before(:each) do
      Member.stub(:find).and_return(member)
    end

    def get_edit
      get :edit, :id => 1
    end

    it "is successful" do
      get_edit
      response.should be_success
    end
  end

end
