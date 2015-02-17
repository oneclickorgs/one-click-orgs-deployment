require 'rails_helper'

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
      @directorships = double("directorships association")
      allow(@organisation).to receive(:directorships).and_return(@directorships)
      allow(@directorships).to receive(:build).and_return(@directorship)
    end

    def get_new
      get :new
    end

    it "builds a new directorship" do
      expect(@directorships).to receive(:build).and_return(@directorship)
      get_new
    end

    it "assigns the new directorship" do
      get_new
      expect(assigns[:directorship]).to eq(@directorship)
    end
  end

  describe "GET external" do
    let(:directorships) {double("directorships", :build => directorship)}
    let(:directorship) {mock_model(Directorship, :build_director => nil).as_new_record}
    let(:member_classes) {double("member classes", :find_by_name => member_class)}
    let(:member_class) {mock_model(MemberClass, :id => 999)}

    before(:each) do
      allow(@organisation).to receive(:directorships).and_return(directorships)
      allow(@organisation).to receive(:member_classes).and_return(member_classes)
    end

    def get_external
      get :external
    end

    it "builds a new directorship" do
      expect(directorships).to receive(:build).and_return(directorship)
      get_external
    end

    it "builds a new director on the directorship" do
      expect(directorship).to receive(:build_director)
      get_external
    end

    it "sets the member_class_id of the director to 'External Director'" do
      expect(member_classes).to receive(:find_by_name).with("External Director").and_return(member_class)
      expect(directorship).to receive(:build_director).with(hash_including(:member_class_id => 999))
      get_external
    end

    it "assigns the new directorship" do
      get_external
      expect(assigns[:directorship]).to eq(directorship)
    end

    it "is successful" do
      get_external
      expect(response).to be_success
    end
  end

  describe "POST create" do
    before(:each) do
      @directorship = mock_model(Directorship,
        :save! => true
      ).as_new_record

      @directorships = double("directors association")
      allow(@organisation).to receive(:directorships).and_return(@directorships)

      allow(@directorships).to receive(:build).and_return(@directorship)

      @directorship_params = {'member_id' => '1'}
    end

    def post_create
      post :create, 'directorship' => @directorship_params
    end

    it "builds the new directorship" do
      expect(@directorships).to receive(:build).with(@directorship_params).and_return(@directorship)
      post_create
    end

    it "saves the new directorship" do
      expect(@directorship).to receive(:save!)
      post_create
    end

    it "redirects to the directors page" do
      post_create
      expect(response).to redirect_to('/directors')
    end

    context "when the new directorship cannot be saved" do
      it "handles the error"
    end
  end

  describe "GET edit" do
    before(:each) do
      @directorship = mock_model(Directorship)

      @directorships = double("directorships association")
      allow(@organisation).to receive(:directorships).and_return(@directorships)
      allow(@directorships).to receive(:find).and_return(@directorship)
    end

    def get_edit
      get :edit, 'id' => '1'
    end

    it "finds the directorship" do
      expect(@directorships).to receive(:find).with('1').and_return(@directorship)
      get_edit
    end

    it "assigns the directorship" do
      get_edit
      expect(assigns[:directorship]).to eq(@directorship)
    end

    it "is successful" do
      get_edit
      expect(response).to be_success
    end
  end

  describe "PUT update" do
    before(:each) do
      @directorship = mock_model(Directorship,
        :save! => nil,
        :update_attributes => nil
      )
      @directorship_params = {'certification' => '1'}

      @directorships = double("directorships association")
      allow(@directorships).to receive(:find).and_return(@directorship)

      allow(@organisation).to receive(:directorships).and_return(@directorships)
    end

    def put_update
      put :update, 'id' => '1', 'directorship' => @directorship_params
    end

    it "finds the directorship" do
      expect(@directorships).to receive(:find).with('1').and_return(@directorship)
      put_update
    end

    it "update the directorship's attributes" do
      expect(@directorship).to receive(:update_attributes).with(@directorship_params)
      put_update
    end

    it "saves the directorship" do
      expect(@directorship).to receive(:save!)
      put_update
    end

    it "should redirect to the directors page" do
      put_update
      expect(response).to redirect_to('/directors')
    end
  end


end
