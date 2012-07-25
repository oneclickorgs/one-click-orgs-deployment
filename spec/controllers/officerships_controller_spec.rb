require 'spec_helper'

describe OfficershipsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET new" do
    before(:each) do
      @officership = mock_model(Officership).as_new_record
      @officerships_association = mock("officerships association")

      @organisation.stub(:officerships).and_return(@officerships_association)
      @officerships_association.stub(:build).and_return(@officership)
      @officership.stub(:build_office)
    end

    def get_new
      get :new
    end

    it "builds a new officership" do
      @officerships_association.should_receive(:build).and_return(@officership)
      get_new
    end

    it "builds a new office on the officership" do
      @officership.should_receive(:build_office)
      get_new
    end

    it "assigns the new officership" do
      get_new
      assigns[:officership].should == @officership
    end

    it "is successful" do
      get_new
      response.should be_success
    end
  end

  describe "POST create" do
    before(:each) do
      @officership_params = {'officer_id' => '1'}
      @officerships_association = mock("officerships association")
      @officership = mock_model(Officership).as_new_record

      @organisation.stub(:officerships).and_return(@officerships_association)
      @officerships_association.stub(:build).and_return(@officership)
      @officership.stub(:save!)
    end
    
    def post_create
      post :create, 'officership' => @officership_params
    end

    it "builds the new officership" do
      @officerships_association.should_receive(:build).with(@officership_params).and_return(@officership)
      post_create
    end

    it "saves the new officership" do
      @officership.should_receive(:save!)
      post_create
    end

    it "redirects to the directors page" do
      post_create
      response.should redirect_to(directors_path)
    end
  end

end
