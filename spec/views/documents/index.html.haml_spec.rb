require 'spec_helper'

describe 'documents/index' do

  it "renders a link to the letter of engagement document" do
    render
    expect(rendered).to have_selector(:a, :href => '/documents/letter_of_engagement')
  end

  it "renders a link to the money laundering form" do
    render
    expect(rendered).to have_selector(:a, :href => '/documents/money_laundering')
  end

end
