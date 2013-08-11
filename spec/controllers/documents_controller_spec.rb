require 'spec_helper'

describe DocumentsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET index" do
    def get_index
      get :index
    end

    it "is successful" do
      get_index
      expect(response).to be_success
    end
  end

  describe "GET show" do
    before(:each) do
      @organisation.stub(:name)
    end

    def get_show
      get :show, :id => 'letter_of_engagement'
    end

    it "is successful" do
      get_show
      expect(response).to be_success
    end
  end

end
