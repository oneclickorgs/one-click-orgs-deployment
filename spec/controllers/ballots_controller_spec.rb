require 'spec_helper'

describe BallotsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET new" do
    before(:each) do
      @elections_association = double("elections association")
      allow(@organisation).to receive(:elections).and_return(@elections_association)

      @election = mock_model(Election)
      allow(@elections_association).to receive(:find).and_return(@election)

      @ballots_association = double("ballots_association")
      allow(@election).to receive(:ballots).and_return(@ballots_association)

      @ballot = mock_model(Ballot).as_new_record
      allow(@ballots_association).to receive(:build).and_return(@ballot)

      @nominations_association = double("nominations association")
      allow(@election).to receive(:nominations).and_return(@nominations_association)

      @agm = mock_model(AnnualGeneralMeeting)
      allow(@election).to receive(:meeting).and_return(@agm)
    end

    def get_new
      get :new, 'election_id' => '1'
    end

    it "finds the election" do
      expect(@elections_association).to receive(:find).with('1').and_return(@election)
      get_new
    end

    it "assigns the election" do
      get_new
      expect(assigns[:election]).to eq(@election)
    end

    it "builds a new ballot" do
      expect(@ballots_association).to receive(:build).and_return(@ballot)
      get_new
    end

    it "assigns the new ballot" do
      get_new
      expect(assigns[:ballot]).to eq(@ballot)
    end

    it "assigns the nominations" do
      get_new
      expect(assigns[:nominations]).to eq(@nominations_association)
    end

    it "should be successful" do
      get_new
      expect(response).to be_success
    end
  end

  describe "POST create" do
    before(:each) do
      @ballot_params = {'ranking_30' => '1'}  
      @elections_association = double("elections association")
      allow(@organisation).to receive(:elections).and_return(@elections_association)
      @election = mock_model(Election)
      allow(@elections_association).to receive(:find).and_return(@election)
      @ballots_association = double("ballots association")
      allow(@election).to receive(:ballots).and_return(@ballots_association)
      @ballot = mock_model(Ballot).as_new_record
      allow(@ballots_association).to receive(:build).and_return(@ballot)
      allow(@ballot).to receive(:member=)
      allow(@ballot).to receive(:save!)
    end

    def post_create
      post :create, 'election_id' => '1', 'ballot' => @ballot_params
    end

    it "finds the election" do
      expect(@elections_association).to receive(:find).with('1').and_return(@election)
      post_create
    end

    it "builds a new ballot" do
      expect(@ballots_association).to receive(:build).with(@ballot_params).and_return(@ballot)
      post_create
    end

    it "sets the owner of the ballot to the current user" do
      expect(@ballot).to receive(:member=).with(@user)
      post_create
    end

    it "saves the ballot" do
      expect(@ballot).to receive(:save!)
      post_create
    end

    it "redirects to the dashboard" do
      post_create
      expect(response).to redirect_to('/')
    end

    context "when ballot cannot be saved" do
      it "handles the error"
    end
  end

end
