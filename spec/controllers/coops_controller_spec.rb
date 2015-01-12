require 'spec_helper'

describe CoopsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
  end

  describe "GET new" do
    before(:each) do
      @member = mock_model(Member)
      allow(Member).to receive(:new).and_return(@member)

      @coop = mock_model(Coop)
      allow(Coop).to receive(:new).and_return(@coop)
    end

    def get_new
      get :new, skip_intro: '1'
    end

    it "builds a new member" do
      expect(Member).to receive(:new).and_return(@member)
      get_new
    end

    it "assigns the new member" do
      get_new
      expect(assigns(:member)).to eq(@member)
    end

    it "builds a new coop" do
      expect(Coop).to receive(:new).and_return(@coop)
      get_new
    end

    it "assigns the new coop" do
      get_new
      expect(assigns(:coop)).to eq(@coop)
    end
  end

  describe "POST create" do
    before(:each) do
      @coop_attributes = {
        'name' => 'Coffee Ventures',
        'subdomain' => 'coffee'
      }
      @member_attributes = {
        'first_name' => "Bob",
        'last_name' => "Smith",
        'email' => 'bob@example.com',
        'password' => 'letmein',
        'password_confirmation' => 'letmein'
      }

      @coop = mock_model(Coop,
        :host => 'coffee.oneclickorgs.com'
      )
      allow(Coop).to receive(:new).and_return(@coop)

      @members_association = double('members association')
      allow(@coop).to receive(:members).and_return(@members_association)

      @member = mock_model(Member)
      allow(@members_association).to receive(:build).and_return(@member)

      allow(@coop).to receive(:save!).and_return(true)
      allow(@member).to receive(:save!).and_return(true)

      allow(@member).to receive(:induct!)

      allow(controller).to receive(:log_in)

      @founder_member_member_class = mock_model(MemberClass)
      @member_classes_association = double("member_classes association")
      allow(@coop).to receive(:member_classes).and_return(@member_classes_association)
      allow(@member_classes_association).to receive(:find_by_name).with('Founder Member').and_return(@founder_member_member_class)
      allow(@member).to receive(:member_class=)

      allow(@member).to receive(:find_or_create_share_account)
      allow(@coop).to receive(:share_account)

      @share_transaction = mock_model(ShareTransaction, :save! => true)
      allow(ShareTransaction).to receive(:create).and_return(@share_transaction)
    end

    def post_create
      post :create, 'coop' => @coop_attributes, 'member' => @member_attributes
    end

    it "builds the co-op" do
      expect(Coop).to receive(:new).with(@coop_attributes).and_return(@coop)
      post_create
    end

    it "builds the member on the co-op" do
      expect(@members_association).to receive(:build).with(@member_attributes).and_return(@member)
      post_create
    end

    it "saves the co-op" do
      expect(@coop).to receive(:save!).and_return(true)
      post_create
    end

    it "saves the member" do
      expect(@member).to receive(:save!).and_return(true)
      post_create
    end

    it "sets the member class of the member to 'Founder Member'" do
      expect(@member).to receive(:member_class=).with(@founder_member_member_class)
      post_create
    end

    it "logs the member in" do
      expect(controller).to receive(:log_in).with(@member)
      post_create
    end

    it "redirects to the dashboard for the new co-op" do
      post_create
      expect(response).to redirect_to 'http://coffee.oneclickorgs.com/'
    end

    describe "when the coop attributes are invalid" do
      it "does not save the member"
      it "renders the new action"
    end

    describe "when the member attributes are invalid" do
      it "does not save the coop"
      it "renders the new action"
    end
  end

end
