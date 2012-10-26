require 'spec_helper'

describe 'share_withdrawals/new' do

  let(:user) {mock_model(Member, :shares_count => 5)}
  let(:share_withdrawal) {mock_model(ShareWithdrawal, :amount => nil, :certification => nil).as_new_record}

  before(:each) do
    view.stub(:current_user).and_return(user)
    assign(:share_withdrawal, share_withdrawal)
  end

  it "renders a field for the amount" do
    render
    rendered.should have_selector(:input, :name => 'share_withdrawal[amount]')
  end

end
