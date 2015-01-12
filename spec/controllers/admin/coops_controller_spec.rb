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
      allow(Coop).to receive(:find).and_return(coop)
    end

    def get_show
      get :show, :id => 1
    end

    it "finds the coop" do
      expect(Coop).to receive(:find).with('1').and_return(coop)
      get_show
    end

    it "assigns the coop" do
      get_show
      expect(assigns[:coop]).to eq(coop)
    end

    it "is successful" do
      get_show
      expect(response).to be_success
    end
  end

end
