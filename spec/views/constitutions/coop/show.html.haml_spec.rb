require 'spec_helper'

describe 'constitutions/coop/show' do

  let(:organisation) {mock_model(Coop,
    :name => "The Friendly Co-op"
  )}
  let(:constitution) {double('constitution', updated_at: Time.new(2014, 1, 1))}

  before(:each) do
    view.stub(:co).and_return(organisation)
    view.stub(:can?).and_return(false)
    stub_template 'shared/_constitution.html.haml' => 'Constitution goes here'
    assign(:constitution, constitution)
  end

  it "renders a link to download a PDF" do
    render
    rendered.should have_selector(:a, :href => '/constitution.pdf')
  end

  it "renders the date the constitution was last changed" do
    render
    expect(rendered).to have_content('last changed on 1 January 2014')
  end

end
