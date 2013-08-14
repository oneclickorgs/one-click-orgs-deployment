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
      @organisation.stub(:elections).and_return(@elections_association)

      @election = mock_model(Election)
      @elections_association.stub(:find).and_return(@election)

      @ballots_association = double("ballots_association")
      @election.stub(:ballots).and_return(@ballots_association)

      @ballot = mock_model(Ballot).as_new_record
      @ballots_association.stub(:build).and_return(@ballot)

      @nominations_association = double("nominations association")
      @election.stub(:nominations).and_return(@nominations_association)

      @agm = mock_model(AnnualGeneralMeeting)
      @election.stub(:meeting).and_return(@agm)
    end

    def get_new
      get :new, 'election_id' => '1'
    end

    it "finds the election" do
      @elections_association.should_receive(:find).with('1').and_return(@election)
      get_new
    end

    it "assigns the election" do
      get_new
      assigns[:election].should == @election
    end

    it "builds a new ballot" do
      @ballots_association.should_receive(:build).and_return(@ballot)
      get_new
    end

    it "assigns the new ballot" do
      get_new
      assigns[:ballot].should == @ballot
    end

    it "assigns the nominations" do
      get_new
      assigns[:nominations].should == @nominations_association
    end

    it "should be successful" do
      get_new
      response.should be_success
    end
  end

  describe "POST create" do
    before(:each) do
      @ballot_params = {'ranking_30' => '1'}  
      @elections_association = double("elections association")
      @organisation.stub(:elections).and_return(@elections_association)
      @election = mock_model(Election)
      @elections_association.stub(:find).and_return(@election)
      @ballots_association = double("ballots association")
      @election.stub(:ballots).and_return(@ballots_association)
      @ballot = mock_model(Ballot).as_new_record
      @ballots_association.stub(:build).and_return(@ballot)
      @ballot.stub(:member=)
      @ballot.stub(:save!)
    end

    def post_create
      post :create, 'election_id' => '1', 'ballot' => @ballot_params
    end

    it "finds the election" do
      @elections_association.should_receive(:find).with('1').and_return(@election)
      post_create
    end

    it "builds a new ballot" do
      @ballots_association.should_receive(:build).with(@ballot_params).and_return(@ballot)
      post_create
    end

    it "sets the owner of the ballot to the current user" do
      @ballot.should_receive(:member=).with(@user)
      post_create
    end

    it "saves the ballot" do
      @ballot.should_receive(:save!)
      post_create
    end

    it "redirects to the dashboard" do
      post_create
      response.should redirect_to('/')
    end

    context "when ballot cannot be saved" do
      it "handles the error"
    end
  end

end
