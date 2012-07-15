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
    
    it "renders a 'Start an electronic vote' button for each draft resolution" do
      render
      rendered.should have_selector(".draft_proposals form[action='/proposals/#{@draft_proposals[0].to_param}/open']")
    end
  end

  context "when user can create a meeting" do
    before(:each) do
      view.stub(:can?).with(:create, Meeting).and_return(true)
    end

    it "renders an 'Add to a meeting' button for each draft resolution" do
      render
      rendered.should have_selector(".draft_proposals input[data-url='/general_meetings/new?resolution_id=#{@draft_proposals[0].to_param}']")
    end
  end
  
  context "when user cannot create a resolution" do
    it "does not render a button to create a resolution"
    it "does not render a button to start an electronic vote for each draft resolution"
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
