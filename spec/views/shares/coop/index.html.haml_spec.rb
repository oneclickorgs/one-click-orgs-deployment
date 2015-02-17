# encoding: UTF-8

require 'rails_helper'

describe 'shares/coop/index' do

  let(:organisation) {mock_model(Coop,
    :name => "Test",
    :share_value_in_pounds => 0.7,
    :minimum_shareholding => 2,
    :interest_rate => 1.34,
    :share_account => mock_model(ShareAccount, :balance => -34)
  )}

  let(:user) {mock_model(Member, :shares_count => nil)}

  let(:task) {mock_model(Task, :to_partial_name => 'task_share_transaction_make_payment')}

  let(:members) {
    [
      mock_model(Member,
        :id => 3000,
        :name => "Bob Smith",
        :find_or_build_share_account => mock_model(ShareAccount,
          :balance => 4
        )
      )
    ]
  }

  before(:each) do
    allow(view).to receive(:co).and_return(organisation)
    allow(view).to receive(:current_user).and_return(user)
    allow(view).to receive(:can?).and_return(false)

    assign(:tasks, [task])
    stub_template('tasks/_task_share_transaction_make_payment' => 'task template')

    assign(:members, members)
  end

  it "displays the current share value" do
    render
    expect(rendered).to have_content("£0.70")
  end

  it "displays the current minimum shareholding" do
    render
    expect(rendered).to have_content("minimum shareholding is 2 shares.")
  end

  it "displays the current interest rate" do
    render
    expect(rendered).to have_content("rate of interest on share capital is 1.34%.")
  end

  it "displays a list of share-related tasks for the current user" do
    render
    expect(rendered).to render_template('tasks/_task_share_transaction_make_payment')
  end

  context "when the organisation allows multiple shareholding" do
    before(:each) do
      allow(organisation).to receive(:single_shareholding?).and_return(false)
    end

    context "when the user can create share applications" do
      before(:each) do
        allow(view).to receive(:can?).with(:create, ShareApplication).and_return(true)
      end

      it "renders a button to apply for more shares" do
        render
        expect(rendered).to have_selector("form[action='/share_applications/new']")
      end
    end

    context "when the user can create ShareWithdrawals" do
      before(:each) do
        allow(view).to receive(:can?).with(:create, ShareWithdrawal).and_return(true)
      end

      it "renders a button to withdraw shares" do
        render
        expect(rendered).to have_selector("form[action='/share_withdrawals/new']")
      end
    end
  end

  context "when user can view ShareAccounts" do
    before(:each) do
      allow(view).to receive(:can?).with(:read, ShareAccount).and_return(true)
    end

    it "renders a table of the members' share ownership" do
      render
      expect(rendered).to have_selector("table.share_account_balances") do |table|
        expect(table).to have_selector("tr#member_3000") do |tr|
          expect(tr).to have_content("Bob Smith")
          expect(tr).to have_content("4")
        end
      end
    end

    it "renders the current organisation share balance" do
      render
      expect(rendered).to have_selector('.organisation_share_account .balance', text: '34')
    end
  end

  context "when the user can view ShareTransactions" do
    let(:organisation_share_withdrawals) {[mock_model(ShareTransaction,
      :id => 3000,
      :from_account => mock_model(ShareAccount,
        :owner => mock_model(Member, :name => "Bob Smith")
      ),
      :created_at => Time.utc(2012, 5, 6, 12, 34, 56),
      :amount => 1,
      :withdrawal_due? => false,
      :withdrawal_due_date => Date.new(2012, 8, 6)
    )]}
    let(:organisation_share_applications) {[mock_model(ShareTransaction,
      :to_account => mock_model(ShareAccount,
        :owner => mock_model(Member, :name => 'Jane Baker')
      ),
      :created_at => Time.utc(2012, 8, 1, 12, 34, 56),
      :amount => 2
    )]}

    before(:each) do
      allow(view).to receive(:can?).with(:read, ShareTransaction).and_return(true)
      assign(:organisation_share_withdrawals, organisation_share_withdrawals)
      assign(:organisation_share_applications, organisation_share_applications)
    end

    it "renders a list of pending share withdrawals" do
      render
      expect(rendered).to have_selector("ul.organisation_share_withdrawals") do |ul|
        expect(ul).to have_content("Bob Smith applied to withdraw 1 share on 6 May 2012.")
        expect(ul).to have_content("Payment will become due on 6 August 2012.")
      end
    end

    it "renders a 'waive notice period' button for share withdrawals which are not due yet" do
      render
      expect(rendered).to have_selector('ul.organisation_share_withdrawals') do |ul|
        expect(ul).to have_selector("form[action='/share_transactions/3000/confirm_approve']")
      end
    end

    it "renders a list of pending share applications" do
      render
      expect(rendered).to have_selector("ul.organisation_share_applications") do |ul|
        expect(ul).to have_content("Jane Baker applied for 2 shares on 1 August 2012.")
        expect(ul).to have_content("A payment of £2 is due.")
      end
    end
  end

  context "when user can update the organisation" do
    before(:each) do
      allow(view).to receive(:can?).with(:update, organisation).and_return(true)
    end

    it "renders a link button to adjust the share value" do
      render
      expect(rendered).to have_selector("form[action='/shares/edit_share_value']")
    end

    it "renders a link button to adjust the minimum shareholding" do
      render
      expect(rendered).to have_selector("form[action='/shares/edit_minimum_shareholding']")
    end

    it "renders a link button to adjust the interest rate" do
      render
      expect(rendered).to have_selector("form[action='/shares/edit_interest_rate']")
    end
  end

end
