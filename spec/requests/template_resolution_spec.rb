require 'spec_helper'

describe "template resolution" do
  
  describe "scoped by organisation class" do
    it "picks an association subtemplate when the organisation is an association" do
      default_association
      association_login
      get '/'
      response.should render_template 'one_click/association/dashboard'
    end
    
    it "picks a company subtemplate when the organisation is a company" do
      default_company
      company_login
      get '/'
      response.should render_template 'one_click/company/dashboard'
    end
    
    it "picks the default template when no subtemplate is available" do
      default_association
      association_login
      get '/proposals'
      response.should render_template 'proposals/index'
    end
  end
  
end
