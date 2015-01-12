require 'rails_helper'

describe ShareApplication do

  it "implements #persisted?" do
    expect(ShareApplication.new.persisted?).to be false
  end

  it "builds a share transaction if not given one" do
    share_application = ShareApplication.new
    expect(share_application.share_transaction).to be_a(ShareTransaction)
  end

  it "accepts attribtues on initialization" do
    share_application = ShareApplication.new(:amount => 5)
    expect(share_application.amount).to eq(5)
  end

  it "delegates 'amount' to the share transaction" do
    expect(ShareApplication.new.amount).to be_nil
  end

  describe "saving" do
    it "saves the share transaction" do
      share_application = ShareApplication.new

      expect(share_application.share_transaction).to receive(:save).and_return(true)

      share_application.save
    end
  end

  describe "validation" do
    let(:member) { mock_model(Member,
      organisation: organisation,
      find_or_build_share_account: nil,
      shares_count: 4
    ) }
    let(:organisation) { mock_model(Organisation,
      maximum_shareholding: 100_000,
      share_account: nil
    ) }

    it "does not allow values that would take the member's total shareholding above the legal maximum" do
      sa = ShareApplication.new(member: member, amount: member.organisation.maximum_shareholding + 1)
      expect(sa).to_not be_valid
      expect(sa.errors[:amount]).to be_present
    end
  end

end
