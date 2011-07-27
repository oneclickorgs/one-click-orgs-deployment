require 'spec_helper'

describe "meetings/show.html.haml" do
  
  before(:each) do
    @meeting = mock_model(Meeting,
      :happened_on => Date.new(2011, 1, 1),
      :minutes => "Here is what happened."
    )
    
    participants = [
      mock_model(Member, :name => "Bob Smith"),
      mock_model(Member, :name => "Sue Baker")
    ]
    @meeting.stub(:participants).and_return(participants)
    
    assign(:meeting, @meeting)
  end
  
  it "renders the participants' names" do
    render
    rendered.should have_selector("ul.participants li", :content => "Bob Smith")
    rendered.should have_selector("ul.participants li", :content => "Sue Baker")
  end
  
  it "renders the minutes" do
    render
    rendered.should have_selector("p", :content => "Here is what happened.")
  end
  
  it "renders the date the meeting happened on" do
    render
    rendered.should include("January 1st, 2011")
  end
  
end
