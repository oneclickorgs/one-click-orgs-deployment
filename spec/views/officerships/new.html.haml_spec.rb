require 'spec_helper'

describe 'officerships/new' do

  before(:each) do
    @officership = mock_model(Officership,
      :certification => nil,
      :office_attributes= => nil
    ).as_new_record
    assign(:officership, @officership)

    @office = mock_model(Office).as_new_record
    @officership.stub(:office).and_return(@office)

    @organisation = mock_model(Coop)
    view.stub(:co).and_return(@organisation)

    @organisation.stub(:directors).and_return([
      mock_model(Director, :id => 1, :name => "Claire Simmons")
    ])
    @organisation.stub(:offices).and_return([
      mock_model(Office, :id => 2, :title => "Treasurer")
    ])

    @organisation.stub(:active?).and_return(true)
  end

  it "renders a select field listing the directors" do
    render
    rendered.should have_selector(:select, :name => 'officership[officer_id]') do |select|
      select.should have_selector(:option, :value => '1', :content => "Claire Simmons")
    end
  end

  it "renders a text field for the office" do
    render
    rendered.should have_selector(:input, :name => 'officership[office_attributes][title]')
  end

  it "renders a certification check box" do
    render
    rendered.should have_selector(:input, :name => 'officership[certification]')
  end

  it "renders a select field for existing offices" do
    render
    rendered.should have_selector(:select, :name => 'officership[office_id]') do |select|
      select.should have_selector(:option, :value => '2', :content => 'Treasurer')
    end
  end

  it "renders a date select for the date elected on" do
    render
    rendered.should have_selector(:select, :name => 'officership[elected_on(1i)]')
    rendered.should have_selector(:select, :name => 'officership[elected_on(2i)]')
    rendered.should have_selector(:select, :name => 'officership[elected_on(3i)]')
  end

  it "renders a submit button" do
    render
    rendered.should have_selector(:input, :type => 'submit')
  end

end
