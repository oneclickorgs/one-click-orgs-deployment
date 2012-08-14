# encoding: UTF-8

require 'spec_helper'

describe 'shares/coop/index' do

  let(:organisation) {mock_model(Coop,
    :share_value_in_pounds => 0.7,
    :minimum_shareholding => 2,
    :interest_rate => 1.34
  )}

  let(:task) {mock_model(Task, :to_partial_name => 'task_share_transaction_make_payment')}

  before(:each) do
    view.stub(:co).and_return(organisation)
    view.stub(:can?).and_return(false)

    assign(:tasks, [task])
    stub_template('tasks/_task_share_transaction_make_payment' => 'task template')
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
