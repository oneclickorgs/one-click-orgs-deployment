require 'spec_helper'

describe 'officerships/new' do

  before(:each) do
    @officership = mock_model(Officership,
      :certification => nil,
      :office_attributes= => nil
    ).as_new_record
    assign(:officership, @officership)

    @office = mock_model(Office).as_new_record
    allow(@officership).to receive(:office).and_return(@office)

    @organisation = mock_model(Coop)
    allow(view).to receive(:co).and_return(@organisation)

    allow(@organisation).to receive(:directors).and_return([
      mock_model(Director, :id => 1, :name => "Claire Simmons"),
      mock_model(Director, :id => 3, :name => "Bob Smith")
    ])
    allow(@organisation).to receive(:offices).and_return([
      mock_model(Office, :id => 2, :title => "Treasurer")
    ])

    allow(@organisation).to receive(:active?).and_return(true)
  end

  it "renders a select field listing the directors" do
    render
    expect(rendered).to have_selector(:select, :name => 'officership[officer_id]') do |select|
      expect(select).to have_selector(:option, :value => '1', :content => "Claire Simmons")
    end
  end

  it "renders a certification check box" do
    render
    expect(rendered).to have_selector(:input, :name => 'officership[certification]')
  end

  it "renders a select field for existing offices" do
    render
    expect(rendered).to have_selector(:select, :name => 'officership[office_id]') do |select|
      expect(select).to have_selector(:option, :value => '2', :content => 'Treasurer')
    end
  end

  it "renders a date select for the date elected on" do
    render
    expect(rendered).to have_selector(:select, :name => 'officership[elected_on(1i)]')
    expect(rendered).to have_selector(:select, :name => 'officership[elected_on(2i)]')
    expect(rendered).to have_selector(:select, :name => 'officership[elected_on(3i)]')
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector(:input, :type => 'submit')
  end

  context "when the officership has been pre-filled with an officer" do
    before(:each) do
      allow(@officership).to receive(:officer_id).and_return(3)
    end

    it "pre-selects the correct officer" do
      render
      expect(rendered).to have_selector(:select, :name => 'officership[officer_id]') do |select|
        expect(select).to have_selector(:option, :value => '3', :content => 'Bob Smith', :selected => 'selected')
      end
    end
  end

end
