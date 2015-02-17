require 'rails_helper'

describe ShareAccount do

  let(:share_account) {ShareAccount.make!(balance: 50)}

  describe '#empty!' do
    let(:member) {mock_model(Member)}
    let(:share_withdrawal) {mock_model(ShareWithdrawal, :save! => true, :approve! => true)}

    before(:each) do
      allow(share_account).to receive(:owner).and_return(member)
      allow(ShareWithdrawal).to receive(:new).and_return(share_withdrawal)
    end

    it "builds a ShareWithdrawal for the full balance of the account" do
      expect(ShareWithdrawal).to receive(:new).with(member: member, amount: 50).and_return(share_withdrawal)
      share_account.empty!
    end

    it "saves the share withdrawal" do
      expect(share_withdrawal).to receive(:save!)
      share_account.empty!
    end

    it "approves the share withdrawal" do
      expect(share_withdrawal).to receive(:approve!)
      share_account.empty!
    end
  end

end
