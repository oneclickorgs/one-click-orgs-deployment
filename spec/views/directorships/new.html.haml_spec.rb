require 'spec_helper'

describe "directorships/new" do

  before(:each) do
    stub_template "directorships/_form" => "directorship form partial"

    @directorship = mock_model(Directorship)
    assign(:directorship, @directorship)
  end

  it "renders the form partial" do
    render
    rendered.should contain("directorship form partial")
  end

end
