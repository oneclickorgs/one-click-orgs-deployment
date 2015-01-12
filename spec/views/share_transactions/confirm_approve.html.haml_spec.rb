require 'rails_helper'

describe 'share_transactions/confirm_approve' do

  let(:share_transaction) {mock_model(ShareTransaction,
    :id => 3000,
    :from_account => from_account,
    :created_at => 1.week.ago,
    :withdrawal_due_date => 3.months.from_now
  )}
  let(:from_account) {mock_model(ShareAccount, :owner => member)}
  let(:member) {mock_model(Member, :name => "Bob Smith")}

  before(:each) do
    assign(:share_transaction, share_transaction)
  end

  it "renders a submit button for the approval form" do
    render
    expect(rendered).to have_selector(:form, :action => '/share_transactions/3000/approve') do |form|
      expect(form).to have_selector(:input, :type => 'submit')
    end
  end

end
