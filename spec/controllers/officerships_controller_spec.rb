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

    it "respects the officer_id parameter" do
      @officerships_association.should_receive(:build).with(hash_including(:officer_id => '1'))
      get :new, :officer_id => '1'
    end

    it "handles the office_id parameter" do
      @officerships_association.should_receive(:build).with(hash_including(:office_id => '1'))
      get :new, :office_id => '1'
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

  describe "GET edit" do
    before(:each) do
      @officership = mock_model(Officership)  
      @officerships_association = mock("officerships association")

      @organisation.stub(:officerships).and_return(@officerships_association)
      @officerships_association.stub(:find).and_return(@officership)
    end

    def get_edit
      get :edit, 'id' => '1'
    end

    it "finds the officership" do
      @officerships_association.should_receive(:find).with('1').and_return(@officership)
      get_edit
    end

    it "assigns the officership" do
      get_edit
      assigns[:officership].should == @officership
    end

    it "is successful" do
      get_edit
      response.should be_success
    end
  end

  describe "PUT update" do
    before(:each) do
      @officership_params = {'certification' => '1'}
      @officership = mock_model(Officership)
      @officerships_association = mock("officerships association")

      @organisation.stub(:officerships).and_return(@officerships_association)
      @officerships_association.stub(:find).and_return(@officership)
      @officership.stub(:update_attributes)
    end

    def put_update
      put :update, 'id' => '1', 'officership' => @officership_params
    end

    it "finds the officership" do
      @officerships_association.should_receive(:find).with('1').and_return(@officership)
      put_update
    end

    it "updates the officership's attributes" do
      @officership.should_receive(:update_attributes).with(@officership_params)
      put_update
    end

    it "redirects to the directors page" do
      put_update
      response.should redirect_to('/directors')
    end

    context "when the officership cannot be updated" do
      it "handles the error"
    end
  end

end
