require 'spec_helper'

describe ShareTransactionsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "PUT approve" do
    let(:share_account) {mock(ShareAccount, :withdrawals => withdrawals)}
    let(:withdrawals) {mock("withdrawals", :find_by_id => share_transaction)}
    let(:share_transaction) {mock_model(ShareTransaction, :approve! => nil)}

    before(:each) do
      @organisation.stub(:share_account).and_return(share_account)
      controller.stub(:can?).with(:update, share_transaction).and_return(true)
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
