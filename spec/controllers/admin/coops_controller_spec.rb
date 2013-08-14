require 'spec_helper'

describe Admin::CoopsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_administrator_login
  end

  describe "GET show" do

    let(:coop) {mock_model(Coop)}

    before(:each) do
      Coop.stub(:find).and_return(coop)
    end

    def get_show
      get :show, :id => 1
    end

    it "finds the coop" do
      Coop.should_receive(:find).with('1').and_return(coop)
      get_show
    end

    it "assigns the coop" do
      get_show
      assigns[:coop].should == coop
    end

    it "is successful" do
      get_show
      response.should be_success
    end
  end

end
