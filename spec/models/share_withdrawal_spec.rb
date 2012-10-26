require 'spec_helper'

describe ShareWithdrawal do

  let(:member) {mock_model(Member, :find_or_build_share_account => member_share_account, :organisation => organisation)}
  let(:organisation) {mock_model(Organisation, :share_account => organisation_share_account)}
  let(:share_transaction) {mock_model(ShareTransaction,
    :from_account= => nil,
    :amount= => nil,
    :to_account= => nil,
    :save => true
  )}
  let(:member_share_account) {mock_model(ShareAccount)}
  let(:organisation_share_account) {mock_model(ShareAccount)}

  before(:each) do
    ShareTransaction.stub(:new).and_return(share_transaction)
  end

  it "has an 'amount' attribute" do
    share_withdrawal = ShareWithdrawal.new
    share_withdrawal.amount = 3
    share_withdrawal.amount.should eq 3
  end

  it "has a 'member' attribute" do
    share_withdrawal = ShareWithdrawal.new
    share_withdrawal.member = member
    share_withdrawal.member.should eq member
  end

  it "has a 'share_transaction' attribute" do
    share_withdrawal = ShareWithdrawal.new
    share_withdrawal.share_transaction.should eq share_transaction
  end

  describe "initializing" do
    it "builds a share transaction" do
      ShareTransaction.should_receive(:new).and_return(share_transaction)
      share_withdrawal = ShareWithdrawal.new
      share_withdrawal.share_transaction.should == share_transaction
    end
  end

  describe "setting" do
    let(:share_withdrawal) {ShareWithdrawal.new}

    it "uses the member attribute to assign the accounts on the share transaction" do
      share_transaction.should_receive(:to_account=).with(organisation_share_account)
      share_transaction.should_receive(:from_account=).with(member_share_account)
      share_withdrawal.member = member
    end

    it "uses the amount attribute to assign the amount on the share transaction" do
      share_transaction.should_receive(:amount=).with(3)
      share_withdrawal.amount = 3
    end
  end

  describe "saving" do
    let(:share_withdrawal) {ShareWithdrawal.new(:member => member, :amount => 3)}

    it "saves" do
      share_withdrawal.save!
      share_withdrawal.should be_persisted
    end

    it "saves the new share transaction" do
      share_transaction.should_receive(:save).and_return(true)
      share_withdrawal.save!
    end
  end

end
