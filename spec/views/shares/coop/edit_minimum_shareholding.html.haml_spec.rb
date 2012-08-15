require 'spec_helper'

describe 'shares/coop/edit_minimum_shareholding' do
  it "renders a text field for the new minimum shareholding" do
    render
    rendered.should have_selector(:input, :name => 'organisation[minimum_shareholding]')
  end

  it "renders a submit button" do
    render
    rendered.should have_selector(:input, :type => 'submit')
  end
end
