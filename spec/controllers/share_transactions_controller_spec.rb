require 'rails_helper'

describe ShareTransactionsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  let(:share_account) {double(ShareAccount, :withdrawals => withdrawals, :deposits => deposits)}
  let(:withdrawals) {double("withdrawals", :find_by_id => nil)}
  let(:deposits) {double("deposits", :find_by_id => nil)}
  let(:share_transaction) {mock_model(ShareTransaction, :approve! => nil)}

  before(:each) do
    allow(@organisation).to receive(:share_account).and_return(share_account)
  end

  describe "GET confirm_approve" do
    before(:each) do
      allow(deposits).to receive(:find_by_id).and_return(share_transaction)
    end

    def get_confirm_approve
      get :confirm_approve, 'id' => '1'
    end

    it "finds the share transaction" do
      expect(deposits).to receive(:find_by_id).with('1').and_return(share_transaction)
      get_confirm_approve
    end

    it "assigns the share transaction" do
      get_confirm_approve
      expect(assigns[:share_transaction]).to eq(share_transaction)
    end

    it "is successful" do
      get_confirm_approve
      expect(response).to be_success
    end

    describe "authorisation" do
      it "is checked"
    end
  end

  describe "PUT approve" do
    before(:each) do
      allow(withdrawals).to receive(:find_by_id).and_return(share_transaction)
      allow(controller).to receive(:can?).with(:update, share_transaction).and_return(true)
      allow(share_transaction).to receive(:can_approve?).and_return(true)
      allow(share_transaction).to receive(:approved?).and_return(true)
    end

    def put_approve
      put :approve, :id => '1'
    end

    it "finds the share transaction" do
      expect(withdrawals).to receive(:find_by_id).with('1').and_return(share_transaction)
      put_approve
    end

    it "approves the share transaction" do
      expect(share_transaction).to receive(:approve!)
      put_approve
    end

    it "sets a notice flash" do
      put_approve
      expect(flash[:notice]).to be_present
    end

    it "redirects" do
      put_approve
      expect(response).to be_redirect
    end

    context "when user is not authorized to approve share transactions" do
      before(:each) do
        allow(controller).to receive(:can?).with(:update, share_transaction).and_return(false)
      end

      it "does not approve the share transaction" do
        expect(share_transaction).not_to receive(:approve!)
        put_approve
      end
    end
  end

end
