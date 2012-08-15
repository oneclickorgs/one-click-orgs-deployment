require 'spec_helper'

describe 'shares/coop/edit_interest_rate' do

  it "renders a field for the new interest rate" do
    render
    rendered.should have_selector(:input, :name => 'organisation[interest_rate]')
  end

  it "renders a submit button" do
    render
    render.should have_selector(:input, :type => 'submit')
  end

end
