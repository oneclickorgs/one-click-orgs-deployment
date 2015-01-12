require 'spec_helper'

describe 'shares/coop/edit_interest_rate' do

  it "renders a field for the new interest rate" do
    render
    expect(rendered).to have_selector(:input, :name => 'organisation[interest_rate]')
  end

  it "renders a submit button" do
    render
    expect(render).to have_selector(:input, :type => 'submit')
  end

end
