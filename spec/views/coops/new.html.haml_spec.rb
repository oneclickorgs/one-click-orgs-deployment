require 'spec_helper'

describe "coops/new" do

  before(:each) do
    @member = mock_model(Member, :terms_and_conditions => nil)
    assign(:member, @member)

    @coop = mock_model(Coop,
      :name => nil,
      :objectives => nil
    )
    assign(:coop, @coop)

    allow(Setting).to receive(:[]).with(:base_domain).and_return("oneclickorgs.com")
  end

  it "renders a form to create a coop" do
    render
    expect(rendered).to have_selector(:form, :action => '/coops') do |form|
      expect(form).to have_selector(:input, :type => 'submit')
    end
  end

  it "renders fields for a new member" do
    render
    expect(rendered).to have_selector(:input, :type => 'text', :name => 'member[first_name]')
    expect(rendered).to have_selector(:input, :type => 'text', :name => 'member[last_name]')
    expect(rendered).to have_selector(:input, :type => 'email', :name => 'member[email]')
    expect(rendered).to have_selector(:input, :type => 'password', :name => 'member[password]')
    expect(rendered).to have_selector(:input, :type => 'password', :name => 'member[password_confirmation]')
  end

  it "renders fields for a new co-op" do
    render
    expect(rendered).to have_selector(:input, :type => 'text', :name => 'coop[name]')
    expect(rendered).to have_selector(:input, :type => 'text', :name => 'coop[subdomain]')
    expect(rendered).to have_selector(:textarea, :name => 'coop[objectives]')
  end

end
