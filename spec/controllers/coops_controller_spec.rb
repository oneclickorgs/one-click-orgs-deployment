require 'spec_helper'

describe CoopsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
  end

  describe "GET new" do
    before(:each) do
      @member = mock_model(Member)
      Member.stub(:new).and_return(@member)

      @coop = mock_model(Coop)
      Coop.stub(:new).and_return(@coop)
    end

    def get_new
      get :new, skip_intro: '1'
    end

    it "builds a new member" do
      Member.should_receive(:new).and_return(@member)
      get_new
    end

    it "assigns the new member" do
      get_new
      assigns(:member).should == @member
    end

    it "builds a new coop" do
      Coop.should_receive(:new).and_return(@coop)
      get_new
    end

    it "assigns the new coop" do
      get_new
      assigns(:coop).should == @coop
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
      Coop.stub(:new).and_return(@coop)

      @members_association = double('members association')
      @coop.stub(:members).and_return(@members_association)

      @member = mock_model(Member)
      @members_association.stub(:build).and_return(@member)

      @coop.stub(:save!).and_return(true)
      @member.stub(:save!).and_return(true)

      @member.stub(:induct!)

      controller.stub(:log_in)

      @founder_member_member_class = mock_model(MemberClass)
      @member_classes_association = double("member_classes association")
      @coop.stub(:member_classes).and_return(@member_classes_association)
      @member_classes_association.stub(:find_by_name).with('Founder Member').and_return(@founder_member_member_class)
      @member.stub(:member_class=)

      @member.stub(:find_or_create_share_account)
      @coop.stub(:share_account)

      @share_transaction = mock_model(ShareTransaction, :save! => true)
      ShareTransaction.stub(:create).and_return(@share_transaction)
    end

    def post_create
      post :create, 'coop' => @coop_attributes, 'member' => @member_attributes
    end

    it "builds the co-op" do
      Coop.should_receive(:new).with(@coop_attributes).and_return(@coop)
      post_create
    end

    it "builds the member on the co-op" do
      @members_association.should_receive(:build).with(@member_attributes).and_return(@member)
      post_create
    end

    it "saves the co-op" do
      @coop.should_receive(:save!).and_return(true)
      post_create
    end

    it "saves the member" do
      @member.should_receive(:save!).and_return(true)
      post_create
    end

    it "sets the member class of the member to 'Founder Member'" do
      @member.should_receive(:member_class=).with(@founder_member_member_class)
      post_create
    end

    it "logs the member in" do
      controller.should_receive(:log_in).with(@member)
      post_create
    end

    it "redirects to the dashboard for the new co-op" do
      post_create
      response.should redirect_to 'http://coffee.oneclickorgs.com/'
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
