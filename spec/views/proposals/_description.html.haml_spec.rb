require 'spec_helper'

describe 'proposals/_description' do
  
  before(:each) do
    @proposal = mock_model(Proposal, :description => "A description", :description? => true)
    view.stub(:proposal).and_return(@proposal)
  end
  
  it "escapes HTML in the description" do
    @proposal.stub(:description).and_return('test123"\'<img src=xyz onerror=alert(1) foo=>')
    render
    rendered.should_not have_selector(:img)
  end
  
end
