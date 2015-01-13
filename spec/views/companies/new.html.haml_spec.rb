require 'rails_helper'

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
    expect(rendered).to have_selector("form[action='/companies']") do |form|
      expect(form).to have_selector("input[type='submit']")
    end
  end
  
  it "renders fields for a new member" do
    render
    expect(rendered).to have_selector("input[type='text'][name='member[first_name]']")
    expect(rendered).to have_selector("input[type='text'][name='member[last_name]']")
    expect(rendered).to have_selector("input[type='email'][name='member[email]']")
    expect(rendered).to have_selector("input[type='password'][name='member[password]']")
    expect(rendered).to have_selector("input[type='password'][name='member[password_confirmation]']")
  end
  
  it "renders fields for a new company" do
    render
    expect(rendered).to have_selector("input[type='text'][name='company[name]']")
    expect(rendered).to have_selector("input[type='text'][name='company[subdomain]']")
  end
  
end
