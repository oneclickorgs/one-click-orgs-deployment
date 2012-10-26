require 'spec_helper'

describe ShareWithdrawalsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "GET new" do
    let(:share_withdrawal) {mock_model(ShareWithdrawal).as_new_record}

    before(:each) do
      ShareWithdrawal.stub(:new).and_return(share_withdrawal)
      @user.stub(:shares_count).and_return(5)
      @organisation.stub(:minimum_shareholding).and_return(1)
    end

    def get_new
      get :new
    end

    it "builds a new share withdrawal" do
      ShareWithdrawal.should_receive(:new).and_return(share_withdrawal)
      get_new
    end

    it "assigns the new share withdrawal" do
      get_new
      assigns[:share_withdrawal].should == share_withdrawal
    end
  end

  describe "PUT create" do
    let(:share_withdrawal_params) {{'amount' => '3'}}
    let(:share_withdrawal) {mock_model(ShareWithdrawal, :member= => nil, :save! => true)}

    before(:each) do
      ShareWithdrawal.stub(:new).and_return(share_withdrawal)
    end

    def put_create
      put :create, 'share_withdrawal' => share_withdrawal_params
    end

    it "builds a new share withdrawal" do
      ShareWithdrawal.should_receive(:new).with(share_withdrawal_params).and_return(share_withdrawal)
      put_create
    end

    it "assigns the current user to the share withdrawal" do
      share_withdrawal.should_receive(:member=).with(@user)
      put_create
    end

    it "saves the share withdrawal" do
      share_withdrawal.should_receive(:save!)
      put_create
    end

    it "redirects to the shares index" do
      put_create
      response.should redirect_to('/shares')
    end
  end

end
