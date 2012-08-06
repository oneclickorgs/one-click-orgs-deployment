require 'spec_helper'

require 'action_view/helpers/form_helper'

describe 'directorships/_form' do

  before(:each) do
    @form = ActionView::Helpers::FormBuilder.new('directorship', @directorship, view, {}, nil)
    view.stub(:form).and_return(@form)

    @members = [
      mock_model(Member, :name => "John Smith", :id => 1)
    ]
    view.stub_chain(:co, :members).and_return(@members)
  end

  it "renders a select field populated with the members" do
    render
    rendered.should have_selector(:select, :name => 'directorship[director_id]') do |select|
      select.should have_selector(:option, :value => '1', :content => "John Smith")
    end
  end

  it "renders a certification check box" do
    render
    rendered.should have_selector(:input, :name => 'directorship[certification]')
  end

  it "renders a date select fields for the directorship's elected-on date" do
    render
    rendered.should have_selector(:select, :name => 'directorship[elected_on(1i)]')
    rendered.should have_selector(:select, :name => 'directorship[elected_on(2i)]')
    rendered.should have_selector(:select, :name => 'directorship[elected_on(3i)]')
  end

  it "renders a submit button" do
    render
    rendered.should have_selector(:input, :type => 'submit')
  end

end
