require 'spec_helper'

describe "resolution_proposals/new" do
  
  before(:each) do
    @resolution_proposal = mock_model(ResolutionProposal)
    assign(:resolution_proposal, @resolution_proposal)
  end
  
  it "renders a description field" do
    render
    rendered.should have_selector("textarea[name='resolution_proposal[description]']")
  end
  
end
