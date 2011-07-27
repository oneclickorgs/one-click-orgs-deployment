require 'spec_helper'

describe "meetings/show.html.haml" do
  
  before(:each) do
    @meeting = mock_model(Meeting)
    participants = [
      mock_model(Member, :name => "Bob Smith"),
      mock_model(Member, :name => "Sue Baker")
    ]
    @meeting.stub(:participants).and_return(participants)
    assign(:meeting, @meeting)
  end
  
  it "renders the participants' names" do
    render
    rendered.should include("Bob Smith")
    rendered.should include("Sue Baker")
  end
  
end
