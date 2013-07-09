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

    Setting.stub(:[]).with(:base_domain).and_return("oneclickorgs.com")
  end

  it "renders a form to create a coop" do
    render
    rendered.should have_selector(:form, :action => '/coops') do |form|
      form.should have_selector(:input, :type => 'submit')
    end
  end

  it "renders fields for a new member" do
    render
    rendered.should have_selector(:input, :type => 'text', :name => 'member[first_name]')
    rendered.should have_selector(:input, :type => 'text', :name => 'member[last_name]')
    rendered.should have_selector(:input, :type => 'email', :name => 'member[email]')
    rendered.should have_selector(:input, :type => 'password', :name => 'member[password]')
    rendered.should have_selector(:input, :type => 'password', :name => 'member[password_confirmation]')
  end

  it "renders fields for a new co-op" do
    render
    rendered.should have_selector(:input, :type => 'text', :name => 'coop[name]')
    rendered.should have_selector(:input, :type => 'text', :name => 'coop[subdomain]')
    rendered.should have_selector(:textarea, :name => 'coop[objectives]')
  end

end
