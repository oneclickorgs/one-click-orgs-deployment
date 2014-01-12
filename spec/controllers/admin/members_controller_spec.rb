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

end
