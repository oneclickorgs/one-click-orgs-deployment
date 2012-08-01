require 'spec_helper'

describe "directorships/edit" do

  before(:each) do
    @directorship = mock_model(Directorship,
      :certification => nil,
      :ended_on => nil,
      :member_name => "John Smith"
    )
    assign(:directorship, @directorship)
  end

  it "renders a certification check box" do
    render
    rendered.should have_selector(:input, :name => 'directorship[certification]')
  end

  it "renders a date select for ended_on" do
    render
    rendered.should have_selector(:select, :name => 'directorship[ended_on(1i)]')
    rendered.should have_selector(:select, :name => 'directorship[ended_on(2i)]')
    rendered.should have_selector(:select, :name => 'directorship[ended_on(3i)]')
  end

  it "renders a submit button" do
    render
    rendered.should have_selector(:input, :type => 'submit')
  end

end
