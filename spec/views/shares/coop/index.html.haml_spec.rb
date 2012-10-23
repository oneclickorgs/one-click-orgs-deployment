# encoding: UTF-8

require 'spec_helper'

describe 'shares/coop/index' do

  let(:organisation) {mock_model(Coop,
    :name => "Test",
    :share_value_in_pounds => 0.7,
    :minimum_shareholding => 2,
    :interest_rate => 1.34
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
    view.stub(:co).and_return(organisation)
    view.stub(:current_user).and_return(user)
    view.stub(:can?).and_return(false)

    assign(:tasks, [task])
    stub_template('tasks/_task_share_transaction_make_payment' => 'task template')

    assign(:members, members)
  end

  it "displays the current share value" do
    render
    rendered.should have_content("£0.70")
  end

  it "displays the current minimum shareholding" do
    render
    rendered.should have_content("minimum shareholding is 2 shares.")
  end

  it "displays the current interest rate" do
    render
    rendered.should have_content("rate of interest on share capital is 1.34%.")
  end

  it "displays a list of share-related tasks for the current user" do
    render
    rendered.should render_template('tasks/_task_share_transaction_make_payment')
  end

  context "when the organisation allows multiple shareholding" do
    before(:each) do
      organisation.stub(:single_shareholding?).and_return(false)
    end

    context "when the user can create share applications" do
      before(:each) do
        view.stub(:can?).with(:create, ShareApplication).and_return(true)
      end

      it "renders a button to apply for more shares" do
        render
        rendered.should have_selector(:input, 'data-url' => '/share_applications/new')
      end
    end
  end

  context "when user can view ShareAccounts" do
    before(:each) do
      view.stub(:can?).with(:read, ShareAccount).and_return(true)
    end

    it "renders a table of the members' share ownership" do
      render
      rendered.should have_selector("table.share_account_balances") do |table|
        table.should have_selector("tr#member_3000") do |tr|
          tr.should have_content("Bob Smith")
          tr.should have_content("4")
        end
      end
    end
  end

  context "when the user can view ShareTransactions" do
    let(:share_withdrawals) {[mock_model(ShareTransaction,
      :id => 3000,
      :from_account => share_account,
      :created_at => Time.utc(2012, 5, 6, 12, 34, 56),
      :amount => 1,
      :withdrawal_due? => false,
      :withdrawal_due_date => Date.new(2012, 8, 6)
    )]}
    let(:share_account) {mock_model(ShareAccount, :owner => member)}
    let(:member) {mock_model(Member, :name => "Bob Smith")}

    before(:each) do
      view.stub(:can?).with(:read, ShareTransaction).and_return(true)
      assign(:share_withdrawals, share_withdrawals)
    end

    it "renders a list of pending share withdrawals" do
      render
      rendered.should have_selector("ul.share_withdrawals") do |ul|
        ul.should have_content("Bob Smith applied to withdraw 1 share on 6 May 2012.")
        ul.should have_content("Payment will become due on 6 August 2012.")
      end
    end

    it "renders a 'waive notice period' button for share withdrawals which are not due yet" do
      render
      rendered.should have_selector('ul.share_withdrawals') do |ul|
        ul.should have_selector(:input, 'data-url' => '/share_transactions/3000/confirm_approve')
      end
    end
  end

  context "when user can update the organisation" do
    before(:each) do
      view.stub(:can?).with(:update, organisation).and_return(true)
    end

    it "renders a link button to adjust the share value" do
      render
      rendered.should have_selector(:input, 'data-url' => '/shares/edit_share_value')
    end

    it "renders a link button to adjust the minimum shareholding" do
      render
      rendered.should have_selector(:input, 'data-url' => '/shares/edit_minimum_shareholding')
    end

    it "renders a link button to adjust the interest rate" do
      render
      rendered.should have_selector(:input, 'data-url' => '/shares/edit_interest_rate')
    end
  end

end
