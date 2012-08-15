require 'spec_helper'

describe 'shares/coop/edit_share_value' do

  it "renders a text field for the new share value" do
    render
    rendered.should have_selector(:input, :name => 'organisation[share_value_in_pounds]')
  end

  it "renders a submit button" do
    render
    rendered.should have_selector(:input, :type => 'submit')
  end

end
