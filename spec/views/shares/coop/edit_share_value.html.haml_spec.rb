require 'rails_helper'

describe 'shares/coop/edit_share_value' do

  it "renders a text field for the new share value" do
    render
    expect(rendered).to have_selector("input[name='organisation[share_value_in_pounds]']")
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector("input[type='submit']")
  end

end
