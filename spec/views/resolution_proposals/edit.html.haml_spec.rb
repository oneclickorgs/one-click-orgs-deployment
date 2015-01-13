require 'rails_helper'

describe 'resolution_proposals/edit' do

  before(:each) do
    @resolution_proposal = mock_model(ResolutionProposal)
    assign(:resolution_proposal, @resolution_proposal)
  end

  it "renders a description field" do
    render
    expect(rendered).to have_selector("textarea[name='resolution_proposal[description]']")
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector("input[type='submit']")
  end

end
