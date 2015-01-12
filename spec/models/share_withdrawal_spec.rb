require 'rails_helper'

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
    allow(ShareTransaction).to receive(:new).and_return(share_transaction)
  end

  it "has an 'amount' attribute" do
    share_withdrawal = ShareWithdrawal.new
    share_withdrawal.amount = 3
    expect(share_withdrawal.amount).to eq 3
  end

  it "has a 'member' attribute" do
    share_withdrawal = ShareWithdrawal.new
    share_withdrawal.member = member
    expect(share_withdrawal.member).to eq member
  end

  it "has a 'share_transaction' attribute" do
    share_withdrawal = ShareWithdrawal.new
    expect(share_withdrawal.share_transaction).to eq share_transaction
  end

  describe "initializing" do
    it "builds a share transaction" do
      expect(ShareTransaction).to receive(:new).and_return(share_transaction)
      share_withdrawal = ShareWithdrawal.new
      expect(share_withdrawal.share_transaction).to eq(share_transaction)
    end
  end

  describe "setting" do
    let(:share_withdrawal) {ShareWithdrawal.new}

    it "uses the member attribute to assign the accounts on the share transaction" do
      expect(share_transaction).to receive(:to_account=).with(organisation_share_account)
      expect(share_transaction).to receive(:from_account=).with(member_share_account)
      share_withdrawal.member = member
    end

    it "uses the amount attribute to assign the amount on the share transaction" do
      expect(share_transaction).to receive(:amount=).with(3)
      share_withdrawal.amount = 3
    end
  end

  describe "saving" do
    let(:share_withdrawal) {ShareWithdrawal.new(:member => member, :amount => 3)}

    it "saves" do
      share_withdrawal.save!
      expect(share_withdrawal).to be_persisted
    end

    it "saves the new share transaction" do
      expect(share_transaction).to receive(:save).and_return(true)
      share_withdrawal.save!
    end
  end

  describe "approving" do
    let(:share_withdrawal) {ShareWithdrawal.new(:member => member, :amount => 3)}

    before(:each) do
      share_withdrawal.save!
    end

    it "approves the share transaction" do
      expect(share_transaction).to receive(:approve!)
      share_withdrawal.approve!
    end
  end

end
