require 'spec_helper'

describe "directorships/edit" do

  before(:each) do
    @directorship = mock_model(Directorship,
      :certification => nil,
      :ended_on => nil,
      :director_name => "John Smith"
    )
    assign(:directorship, @directorship)
  end

  it "renders a certification check box" do
    render
    expect(rendered).to have_selector(:input, :name => 'directorship[certification]')
  end

  it "renders a date select for ended_on" do
    render
    expect(rendered).to have_selector(:select, :name => 'directorship[ended_on(1i)]')
    expect(rendered).to have_selector(:select, :name => 'directorship[ended_on(2i)]')
    expect(rendered).to have_selector(:select, :name => 'directorship[ended_on(3i)]')
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector(:input, :type => 'submit')
  end

end
