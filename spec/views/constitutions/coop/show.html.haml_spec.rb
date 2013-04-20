require 'spec_helper'

describe 'constitutions/coop/show' do

  let(:organisation) {mock_model(Coop,
    :name => "The Friendly Co-op"
  )}

  before(:each) do
    view.stub(:co).and_return(organisation)
    view.stub(:can?).and_return(false)
    stub_template 'shared/_constitution.html.haml' => 'Constitution goes here'
  end

  it "renders a link to download a PDF" do
    render
    rendered.should have_selector(:a, :href => '/constitution.pdf')
  end

end
