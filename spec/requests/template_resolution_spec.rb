require 'spec_helper'

describe "template resolution" do
  
  describe "scoped by organisation class" do
    it "picks an association subtemplate when the organisation is an association" do
      default_association
      association_login
      get '/'
      expect(@rendered_templates).to include('one_click/association/dashboard.html.haml')
    end
    
    it "picks a company subtemplate when the organisation is a company" do
      default_company
      company_login
      get '/'
      expect(@rendered_templates).to include('one_click/company/dashboard.html.haml')
    end
    
    it "picks the default template when no subtemplate is available" do
      default_association
      association_login
      get '/proposals'
      expect(@rendered_templates).to include('proposals/index.html.haml')
    end
  end
  
  # Since Rails 3.1, the test case for integration/request tests doesn't report
  # the true filesystem path to the templates rendered; instead it reports
  # the simplified virtual path.
  # 
  # As a result, we cannot check precisely which file was rendered by simply using
  # the built-in assert_template / response.should render_template calls.
  # 
  # The following code listens for all the internal template render
  # calls, pulls out the filesystem path for each template rendered, and collects
  # them all so we can check through them later.
  
  before(:each) do
    @rendered_templates = []
    ::ActiveSupport::Notifications.subscribe("render_template.action_view") do |name, start, finish, id, payload|
      @rendered_templates << payload[:identifier].sub("#{Rails.root}/", "").sub(/^app\/views\//, "")
    end
  end
  
  after(:each) do
    ::ActiveSupport::Notifications.unsubscribe("render_template.action_view")
  end
  
end
