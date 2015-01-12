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
      allow(ShareWithdrawal).to receive(:new).and_return(share_withdrawal)
      allow(@user).to receive(:shares_count).and_return(5)
      allow(@organisation).to receive(:minimum_shareholding).and_return(1)
    end

    def get_new
      get :new
    end

    it "builds a new share withdrawal" do
      expect(ShareWithdrawal).to receive(:new).and_return(share_withdrawal)
      get_new
    end

    it "assigns the new share withdrawal" do
      get_new
      expect(assigns[:share_withdrawal]).to eq(share_withdrawal)
    end
  end

  describe "PUT create" do
    let(:share_withdrawal_params) {{'amount' => '3'}}
    let(:share_withdrawal) {mock_model(ShareWithdrawal, :member= => nil, :save! => true)}

    before(:each) do
      allow(ShareWithdrawal).to receive(:new).and_return(share_withdrawal)
    end

    def put_create
      put :create, 'share_withdrawal' => share_withdrawal_params
    end

    it "builds a new share withdrawal" do
      expect(ShareWithdrawal).to receive(:new).with(share_withdrawal_params).and_return(share_withdrawal)
      put_create
    end

    it "assigns the current user to the share withdrawal" do
      expect(share_withdrawal).to receive(:member=).with(@user)
      put_create
    end

    it "saves the share withdrawal" do
      expect(share_withdrawal).to receive(:save!)
      put_create
    end

    it "redirects to the shares index" do
      put_create
      expect(response).to redirect_to('/shares')
    end
  end

end
