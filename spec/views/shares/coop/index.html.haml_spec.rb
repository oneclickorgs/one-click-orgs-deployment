# encoding: UTF-8

require 'spec_helper'

describe 'shares/coop/index' do

  let(:organisation) {mock_model(Coop,
    :share_value_in_pounds => 0.7
  )}

  before(:each) do
    view.stub(:co).and_return(organisation)
    view.stub(:can?).and_return(false)
  end

  it "displays the current share value" do
    render
    rendered.should have_content("£0.70")
  end

  context "when user can create Clauses" do
    before(:each) do
      view.stub(:can?).with(:update, organisation).and_return(true)
    end

    it "renders a link button to adjust the share value" do
      render
      rendered.should have_selector(:input, 'data-url' => '/shares/edit_share_value')
    end
  end

end
