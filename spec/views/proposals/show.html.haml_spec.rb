require 'spec_helper'

describe "proposals/show" do
  
  before(:each) do
    @proposal = mock_model(Proposal,
      :title => "Buy more tea",
      :open? => false,
      :accepted? => true,
      :proposer => mock_model(Member,
        :gravatar_url => gravatar_url,
        :name => "Bob Smith"
      ),
      :creation_date => 1.week.ago,
      :description? => false
    )
    assign(:proposal, @proposal)
    
    @comments = []
    assign(:comments, @comments)
    
    @comment = mock_model(Comment, :body => nil).as_new_record
    assign(:comment, @comment)
    
    stub_template 'proposals/_description' => "description"
    stub_template 'proposals/_vote_count' => "vote count"
  end
  
  it "escapes HTML in the comments" do
    @comments << mock_model(Comment,
      :body => '<a href="something">Text</a>',
      :author => mock_model(Member,
        :gravatar_url => gravatar_url,
        :name => "Bob Smith"
      ),
      :created_at => 1.day.ago
    )
    
    render
    expect(rendered).to include('&lt;a href=&quot;something&quot;&gt;Text&lt;/a&gt;')
  end
  
end
