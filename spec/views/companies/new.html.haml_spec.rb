require 'spec_helper'

describe "companies/new" do
  
  before(:each) do
    @member = mock_model(Member,
      :first_name => nil,
      :last_name => nil,
      :email => nil,
      :password => nil,
      :password_confirmation => nil
    )
    assign(:member, @member)
    
    @company = mock_model(Company,
      :subdomain => nil,
      :name => nil
    )
    assign(:company, @company)
  end
  
  it "renders a form to create a company" do
    render
    rendered.should have_selector(:form, :action => '/companies') do |form|
      form.should have_selector(:input, :type => 'submit')
    end
  end
  
  it "renders fields for a new member" do
    render
    rendered.should have_selector(:input, :type => 'text', :name => 'member[first_name]')
    rendered.should have_selector(:input, :type => 'text', :name => 'member[last_name]')
    rendered.should have_selector(:input, :type => 'text', :name => 'member[email]')
    rendered.should have_selector(:input, :type => 'password', :name => 'member[password]')
    rendered.should have_selector(:input, :type => 'password', :name => 'member[password_confirmation]')
  end
  
  it "renders fields for a new company" do
    render
    rendered.should have_selector(:input, :type => 'text', :name => 'company[name]')
    rendered.should have_selector(:input, :type => 'text', :name => 'company[subdomain]')
  end
  
end
