require 'spec_helper'

describe "one_click/_resignation" do
  
  before(:each) do
    @member_name = "Bob Smith"
    @event = {:object => mock_model(Resignation,
      :member => mock_model(Member,
        :name => @member_name
      )
    )}
    view.stub(:event).and_return(@event)
  end
  
  it "displays the name of the member" do
    render
    rendered.should contain(@member_name)
  end
  
  it "displays the word 'resigned'" do
    render
    rendered.should contain('resigned')
  end
  
end
