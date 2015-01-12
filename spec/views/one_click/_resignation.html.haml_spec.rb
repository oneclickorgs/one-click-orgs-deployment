require 'rails_helper'

describe "one_click/_resignation" do
  
  before(:each) do
    @member_name = "Bob Smith"
    @event = {:object => mock_model(Resignation,
      :member => mock_model(Member,
        :name => @member_name
      )
    )}
    allow(view).to receive(:event).and_return(@event)
  end
  
  it "displays the name of the member" do
    render
    expect(rendered).to contain(@member_name)
  end
  
  it "displays the word 'resigned'" do
    render
    expect(rendered).to contain('resigned')
  end
  
end
