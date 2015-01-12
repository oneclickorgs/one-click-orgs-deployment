require 'rails_helper'

describe 'shares/coop/edit_minimum_shareholding' do
  it "renders a text field for the new minimum shareholding" do
    render
    expect(rendered).to have_selector(:input, :name => 'organisation[minimum_shareholding]')
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector(:input, :type => 'submit')
  end
end
