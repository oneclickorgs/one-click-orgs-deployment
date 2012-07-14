require 'spec_helper'

describe "proposals/coop/index" do
  
  before(:each) do
    view.stub(:can?).and_return(false)
    
    @proposals = [mock_model(Resolution, :description => "Open proposal description")]
    assign(:proposals, @proposals)
  end
  
  it "renders a list of currently-open proposals" do
    render
    rendered.should have_selector('.proposals', :content => "Open proposal description")
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
  
end
