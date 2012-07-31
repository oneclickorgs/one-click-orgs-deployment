require 'spec_helper'

describe DirectorshipsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET new" do
    before(:each) do
      @directorship = mock_model(Directorship)
      @organisation.stub(:build_directorship).and_return(@directorship)
    end

    def get_new
      get :new
    end

    it "builds a new directorship" do
      @organisation.should_receive(:build_directorship).and_return(@directorship)
      get_new
    end

    it "assigns the new directorship" do
      get_new
      assigns[:directorship].should == @directorship
    end
  end

  describe "POST create" do
    before(:each) do
      @directorship = mock_model(Directorship,
        :save! => true
      ).as_new_record

      @organisation.stub(:build_directorship).and_return(@directorship)

      @directorship_params = {'member_id' => '1'}
    end

    def post_create
      post :create, 'directorship' => @directorship_params
    end

    it "builds the new directorship" do
      @organisation.should_receive(:build_directorship).with(@directorship_params).and_return(@directorship)
      post_create
    end

    it "saves the new directorship" do
      @directorship.should_receive(:save!)
      post_create
    end

    it "redirects to the directors page" do
      post_create
      response.should redirect_to('/directors')
    end

    context "when the new directorship cannot be saved" do
      it "handles the error"
    end
  end

  describe "GET edit" do
    before(:each) do
      @directorship = mock_model(Directorship)

      Directorship.stub(:find).and_return(@directorship)
    end

    def get_edit
      get :edit, 'id' => '1'
    end

    it "finds the directorship" do
      Directorship.should_receive(:find).with('1').and_return(@directorship)
      get_edit
    end

    it "assigns the directorship" do
      get_edit
      assigns[:directorship].should == @directorship
    end

    it "is successful" do
      get_edit
      response.should be_success
    end
  end

  describe "PUT update" do
    before(:each) do
      @directorship = mock_model(Directorship,
        :save! => nil,
        :update_attributes => nil
      )
      @directorship_params = {'certification' => '1'}

      Directorship.stub(:find).and_return(@directorship)
    end

    def put_update
      put :update, 'id' => '1', 'directorship' => @directorship_params
    end

    it "finds the directorship" do
      Directorship.should_receive(:find).with('1').and_return(@directorship)
      put_update
    end

    it "update the directorship's attributes" do
      @directorship.should_receive(:update_attributes).with(@directorship_params)
      put_update
    end

    it "saves the directorship" do
      @directorship.should_receive(:save!)
      put_update
    end

    it "should redirect to the directors page" do
      put_update
      response.should redirect_to('/directors')
    end
  end


end
