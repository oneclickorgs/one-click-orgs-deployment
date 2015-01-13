require 'rails_helper'

describe "meetings/show" do
  
  before(:each) do
    @meeting = mock_model(Meeting,
      :happened_on => Date.new(2011, 1, 1),
      :minutes => "Here is what happened.",
      :to_param => '1'
    )
    
    participants = [
      mock_model(Member, :name => "Bob Smith"),
      mock_model(Member, :name => "Sue Baker")
    ]
    allow(@meeting).to receive(:participants).and_return(participants)
    
    assign(:meeting, @meeting)
    
    @comments = []
    assign(:comments, @comments)
    
    @comment = mock_model(Comment, :body => nil).as_new_record
    assign(:comment, @comment)
  end
  
  it "renders the participants' names" do
    render
    expect(rendered).to have_selector("ul.participants li", :text => "Bob Smith")
    expect(rendered).to have_selector("ul.participants li", :text => "Sue Baker")
  end
  
  it "renders the minutes" do
    render
    expect(rendered).to have_selector("p", :text => "Here is what happened.")
  end
  
  it "renders the date the meeting happened on" do
    render
    expect(rendered).to include("January 1st, 2011")
  end
  
  describe "comments" do
    it "renders a comment form" do
      render
      expect(rendered).to have_selector("form[action='/meetings/1/comments']") do |form|
        expect(form).to have_selector("textarea[name='comment[body]']")
        expect(form).to have_selector("input[type='submit']")
      end
    end
  end
  
end
