require 'spec_helper'

describe "proposals/coop/index" do
  
  before(:each) do
    view.stub(:can?).and_return(false)
    
    @proposals = [mock_model(Resolution, :description => "Open proposal description")]
    assign(:proposals, @proposals)
    
    @draft_proposals = [mock_model(Resolution, :description => "Draft proposal description")]
    assign(:draft_proposals, @draft_proposals)
    
    @resolution_proposals = [mock_model(ResolutionProposal, :description => "Suggested resolution description")]
    assign(:resolution_proposals, @resolution_proposals)
    
    stub_template "proposals/_vote" => "vote partial"
  end
  
  it "renders a list of currently-open proposals" do
    render
    rendered.should have_selector('.proposals', :content => "Open proposal description")
  end
  
  it "renders the voting partial for each open proposal" do
    render
    rendered.should contain("vote partial")
  end
  
  it "renders a list of draft resolutions" do
    render
    rendered.should have_selector('.draft_proposals', :content => "Draft proposal description")
  end
  
  it "renders a list of suggested resolutions" do
    render
    rendered.should have_selector('.resolution_proposals', :content => "Suggested resolution description")
  end
  
  context "when user can create a resolution" do
    before(:each) do
      view.stub(:can?).with(:create, Resolution).and_return(true)
    end
    
    it "renders a button to create a resolution" do
      render
      rendered.should have_css("input[class='button-form'][data-url='/resolutions/new']")
    end
  end
  
  context "when user cannot create a resolution" do
    it "does not render a button to create a resolution"
  end
  
  context "when user can suggest a resolution" do
    before(:each) do
      view.stub(:can?).with(:create, ResolutionProposal).and_return(true)
    end
    
    it "renders a button to create a suggested resolution" do
      render
      rendered.should have_css("input[class='button-form'][data-url='/resolution_proposals/new']")
    end
  end
end
