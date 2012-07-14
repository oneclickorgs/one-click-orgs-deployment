require 'spec_helper'

describe 'board_resolutions/new' do
  
  before(:each) do
    @board_resolution = mock_model(BoardResolution,
      :draft => nil
    )
    assign(:board_resolution, @board_resolution)
  end
  
  it "renders a text area for the description" do
    render
    rendered.should have_selector("textarea[name='board_resolution[description]']")
  end
  
  it "renders a radio button to set 'draft' to false" do
    render
    rendered.should have_selector("input[type=radio][name='board_resolution[draft]'][value=false]")
  end
  
  it "renders a radio button to set 'draft' to true" do
    render
    rendered.should have_selector("input[type=radio][name='board_resolution[draft]'][value=true]")
  end
  
  it "renders a submit button" do
    render
    rendered.should have_selector("input[type=submit]")
  end
  
end
