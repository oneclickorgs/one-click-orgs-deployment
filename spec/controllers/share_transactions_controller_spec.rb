require 'spec_helper'

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
    @organisation.stub(:share_account).and_return(share_account)
  end

  describe "GET confirm_approve" do
    before(:each) do
      deposits.stub(:find_by_id).and_return(share_transaction)
    end

    def get_confirm_approve
      get :confirm_approve, 'id' => '1'
    end

    it "finds the share transaction" do
      deposits.should_receive(:find_by_id).with('1').and_return(share_transaction)
      get_confirm_approve
    end

    it "assigns the share transaction" do
      get_confirm_approve
      assigns[:share_transaction].should == share_transaction
    end

    it "is successful" do
      get_confirm_approve
      response.should be_success
    end

    describe "authorisation" do
      it "is checked"
    end
  end

  describe "PUT approve" do
    before(:each) do
      withdrawals.stub(:find_by_id).and_return(share_transaction)
      controller.stub(:can?).with(:update, share_transaction).and_return(true)
      share_transaction.stub(:can_approve?).and_return(true)
      share_transaction.stub(:approved?).and_return(true)
    end

    def put_approve
      put :approve, :id => '1'
    end

    it "finds the share transaction" do
      withdrawals.should_receive(:find_by_id).with('1').and_return(share_transaction)
      put_approve
    end

    it "approves the share transaction" do
      share_transaction.should_receive(:approve!)
      put_approve
    end

    it "sets a notice flash" do
      put_approve
      flash[:notice].should be_present
    end

    it "redirects" do
      put_approve
      response.should be_redirect
    end

    context "when user is not authorized to approve share transactions" do
      before(:each) do
        controller.stub(:can?).with(:update, share_transaction).and_return(false)
      end

      it "does not approve the share transaction" do
        share_transaction.should_not_receive(:approve!)
        put_approve
      end
    end
  end

end
