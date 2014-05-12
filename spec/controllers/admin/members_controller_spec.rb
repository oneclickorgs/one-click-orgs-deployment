require 'spec_helper'

describe Admin::MembersController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_administrator_login
  end

  describe 'GET index' do
    let(:members_association) {double('members association')}

    def get_index
      get :index
    end

    it "finds and assigns the members" do
      expect(Member).to receive(:all).and_return(members_association)
      get_index
      expect(assigns[:members]).to eq(members_association)
    end
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

  describe "GET active_organisations" do
    let(:active_organisations) {[mock_model(Coop)]}
    let(:members) {[mock_model(Member)]}

    before(:each) do
      allow(Coop).to receive(:active).and_return(active_organisations)
      active_organisations.each{|o| allow(o).to receive(:members).and_return(members)}
    end

    def get_active_organisations
      get :active_organisations
    end

    it "finds members from active organisations" do
      active_organisations.each{|o| expect(o).to receive(:members)}
      get_active_organisations
    end

    it "assigns the members" do
      get_active_organisations
      expect(assigns[:members]).to eq(members)
    end

    it "is successful" do
      get_active_organisations
      expect(response).to be_success
    end
  end

  describe "GET proposed_organisations" do
    let(:proposed_organisations) {[mock_model(Coop)]}
    let(:members) {[mock_model(Member)]}

    before(:each) do
      allow(Coop).to receive(:proposed).and_return(proposed_organisations)
      proposed_organisations.each{|o| allow(o).to receive(:members).and_return(members)}
    end

    def get_proposed_organisations
      get :proposed_organisations
    end

    it "finds members from proposed organisations" do
      proposed_organisations.each{|o| expect(o).to receive(:members)}
      get_proposed_organisations
    end

    it "assigns the members" do
      get_proposed_organisations
      expect(assigns[:members]).to eq(members)
    end

    it "is successful" do
      get_proposed_organisations
      expect(response).to be_success
    end
  end

end
