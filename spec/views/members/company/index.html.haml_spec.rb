require 'spec_helper'

describe "members/company/index" do

  before(:each) do
    @organisation = mock_model(Company)
    assign(:current_organisation, @organisation)
    allow(view).to receive(:current_organisation).and_return(@organisation)
    allow(view).to receive(:co).and_return(@organisation)
    install_organisation_resolver(@organisation)

    @director = mock_model(Director,
      :email => nil,
      :first_name => nil,
      :last_name => nil,
      :elected_on => nil,
      :certification => nil,
      :age_certification => nil
    ).as_new_record
    assign(:director, @director)

    @members = [
      mock_model(Director, :name => "Bob Smith", :email => "bob@example.com", :gravatar_url => 'http://www.gravatar.com/avatar/a3406e66dc2a5e80bbc2fd7d5342cc22?s=24&d=mm', :last_logged_in_at => nil, :stood_down_on => nil, :certification => nil),
      mock_model(Director, :name => "Sue Baker", :email => "sue@example.com", :gravatar_url => 'http://www.gravatar.com/avatar/a3406e66dc2a5e80bbc2fd7d5342cc22?s=24&d=mm', :last_logged_in_at => nil, :stood_down_on => nil, :certification => nil)
    ]
  end

  it "renders a list of directors" do
    render
    expect(rendered).to have_selector('table.members') do |table|
      @members.each do |member|
        expect(table).to have_selector('tr', :content => member.name)
      end
    end
  end

  it "renders a form-reveal button 'Stand down' for each director" do
    render
    @members.each do |member|
      expect(rendered).to have_selector("tr[id='director_#{member.id}'] input[type='button'][class='button-form-show'][value='Stand down']")
    end
  end

  it "renders a stand-down form for each director" do
    render
    expect(rendered).to have_selector("select[name='director[stood_down_on(1i)]']")
    expect(rendered).to have_selector("select[name='director[stood_down_on(2i)]']")
    expect(rendered).to have_selector("select[name='director[stood_down_on(3i)]']")
    expect(rendered).to have_selector("input[name='director[certification]'][type='checkbox']")
  end

  it "renders a form-reveal button 'Add a new director'" do
    render
    expect(rendered).to have_selector(:input, :type => 'button', :value => 'Add a new director', :class => 'button-form-show')
  end

  it "renders a new director form" do
    render
    expect(rendered).to have_selector(:form, :action => '/directors') do |form|
      expect(form).to have_selector(:input, :type => 'email', :name => 'director[email]')
      expect(form).to have_selector(:input, :type => 'text', :name => 'director[first_name]')
      expect(form).to have_selector(:input, :type => 'text', :name => 'director[last_name]')
      expect(form).to have_selector(:select, :name => 'director[elected_on(1i)]')
      expect(form).to have_selector(:select, :name => 'director[elected_on(2i)]')
      expect(form).to have_selector(:select, :name => 'director[elected_on(3i)]')
      expect(form).to have_selector(:input, :type => 'checkbox', :name => 'director[certification]')
      expect(form).to have_selector(:input, :type => 'checkbox', :name => 'director[age_certification]')
      expect(form).to have_selector(:input, :type => 'submit')
    end
  end

end
