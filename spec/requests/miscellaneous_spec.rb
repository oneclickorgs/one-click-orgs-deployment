require 'rails_helper'

describe "miscellaneous requests" do

  include RequestSpecHelper

  describe "internally-generated 404" do
    before(:each) do
      association_login
      get '/proposals/9999999'
    end
    
    it "should render the public/404.html file" do
      expect(response.body).to match(/The page you were looking for/)
    end
    
    it "should not render using the application layout" do
      expect(page).not_to have_selector "div.control_bar"
    end
  end
end
