require 'spec_helper'

describe ShareTransaction do

  it "updates the accounts' balances"

  describe "withdrawal due dates" do
    it "calculates the withdrawal due date as three months after the creation date" do
      share_transaction = ShareTransaction.make(:created_at => Time.utc(2011, 11, 30))
      expect(share_transaction.withdrawal_due_date).to eq Date.new(2012, 2, 29)
    end

    describe "#withdrawal_due?" do
      it "returns false when the withdrawal due date is in the future" do
        share_transaction = ShareTransaction.make
        allow(share_transaction).to receive(:withdrawal_due_date).and_return(Date.today.advance(:days => 1))
        expect(share_transaction.withdrawal_due?).to eq false
      end

      it "returns true when the withdrawal due date is today" do
        share_transaction = ShareTransaction.make
        allow(share_transaction).to receive(:withdrawal_due_date).and_return(Date.today)
        expect(share_transaction.withdrawal_due?).to eq true
      end
    end
  end

  describe "tasks" do
    context "when transaction is a share application" do
      let(:share_transaction) {ShareTransaction.make(
        :from_account => coop_account,
        :to_account => member_account,
        :amount => 1
      )}
      let(:coop_account) {mock_model(ShareAccount, :owner => coop)}
      let(:member_account) {mock_model(ShareAccount, :owner => member)}
      let(:member_tasks) {double('member tasks association', :create => nil)}
      let(:secretary_tasks) {double('secretary tasks association', :create => nil)}
      let(:coop) {mock_model(Coop, :secretary => secretary, :domain => 'test', :name => "Test")}
      let(:secretary) {mock_model(Member, :tasks => secretary_tasks, :name => "Sally Secretary", :email => "secretary@example.com")}
      let(:member) {mock_model(Member, :tasks => member_tasks, :organisation => coop, :name => "Bob Smith")}

      it "creates a task for the member to make the payment" do
        expect(member_tasks).to receive(:create).with(:subject => share_transaction, :action => :make_payment)
        share_transaction.save!
      end

      it "creates a task for the secretary to mark the payment received" do
        expect(secretary_tasks).to receive(:create).with(:subject => share_transaction, :action => :mark_payment_received)
        share_transaction.save!
      end
    end
  end

  describe "daily job" do
    let(:organisation) {Coop.make!}
    let(:organisation_share_account) {ShareAccount.make!(:owner => organisation)}
    let(:member_account) {ShareAccount.make!(:owner => Member.make!)}
    let!(:secretary) {organisation.members.make!(:secretary)}

    it "exists" do
      expect {ShareTransaction.run_daily_job}.to_not raise_error
    end

    it "creates a task for each withdrawal that is due" do
      due_withdrawal = ShareTransaction.make!(:to_account => organisation_share_account, :created_at => 4.months.ago)
      recent_withdrawal = ShareTransaction.make!(:to_account => organisation_share_account, :created_at => 1.week.ago)
      application = ShareTransaction.make!(:to_account => member_account, :created_at => 4.months.ago)

      expect {
        ShareTransaction.run_daily_job
      }.to change{secretary.tasks.count}.by(1)
    end
  end

end
