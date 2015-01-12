require 'rails_helper'

require 'action_view/helpers/form_helper'

describe 'directorships/_form' do

  before(:each) do
    @form = ActionView::Helpers::FormBuilder.new('directorship', @directorship, view, {}, nil)
    allow(view).to receive(:form).and_return(@form)

    @members = [
      mock_model(Member, :name => "John Smith", :id => 1)
    ]
    view.stub_chain(:co, :members).and_return(@members)
    view.stub_chain(:co, :directors).and_return([])

    view.stub_chain(:co, :active?).and_return(true)
  end

  it "renders a select field populated with the members" do
    render
    expect(rendered).to have_selector(:select, :name => 'directorship[director_id]') do |select|
      expect(select).to have_selector(:option, :value => '1', :content => "John Smith")
    end
  end

  it "renders a certification check box" do
    render
    expect(rendered).to have_selector(:input, :name => 'directorship[certification]')
  end

  it "renders a date select fields for the directorship's elected-on date" do
    render
    expect(rendered).to have_selector(:select, :name => 'directorship[elected_on(1i)]')
    expect(rendered).to have_selector(:select, :name => 'directorship[elected_on(2i)]')
    expect(rendered).to have_selector(:select, :name => 'directorship[elected_on(3i)]')
  end

  it "renders a submit button" do
    render
    expect(rendered).to have_selector(:input, :type => 'submit')
  end

  it "renders a link to appoint a external director" do
    render
    expect(rendered).to have_selector(:a, :href => '/directorships/new/external')
  end

end
