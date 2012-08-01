require 'spec_helper'

describe 'officerships/edit' do

  before(:each) do
    @officership = mock_model(Officership,
      :certification => nil,
      :ended_on => nil,
      :officer_name => "John Smith",
      :office_title => "Treasurer"
    )
    assign(:officership, @officership)
  end

  it "renders a certification check box" do
    render
    rendered.should have_selector(:input, :name => 'officership[certification]')
  end

  it "renders a submit button" do
    render
    rendered.should have_selector(:input, :type => 'submit')
  end

end
