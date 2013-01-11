require 'spec_helper'

describe "Multi-tenancy" do
  describe "when the app is newly installed" do
    it "should redirect all requests to the setup page" do
      get 'http://oneclickorgs.com/'
      response.should redirect_to('http://oneclickorgs.com/setup')
    end
    
    describe "visiting the setup page" do
      it "should show a form to set the base domain and the signup domain" do
        get 'http://oneclickorgs.com/setup'
        response.should have_selector("form[action='/setup/create_domains']") do |form|
          form.should have_selector("input[name='base_domain']")
          form.should have_selector("input[name='signup_domain']")
          form.should have_selector("input[type=submit]")
        end
      end
      
      it "should auto-detect the base domain" do
        get 'http://oneclickorgs.com/setup'
        response.should have_selector("input[name='base_domain'][value='oneclickorgs.com']")
      end
      
      it "should auto-suggest the setup domain" do
        get 'http://oneclickorgs.com/setup'
        response.should have_selector("input[name='signup_domain'][value='oneclickorgs.com']")
      end
    end
    
    describe "setting the domains" do
      before(:each) do
        post 'http://oneclickorgs.com/setup/create_domains', :base_domain => 'oneclickorgs.com', :signup_domain => 'signup.oneclickorgs.com'
      end
      
      it "should save the base domain setting" do
        Setting[:base_domain].should == 'oneclickorgs.com'
      end
      
      it "should save the signup domain setting" do
        Setting[:signup_domain].should == 'signup.oneclickorgs.com'
      end
      
      it "should redirect to the association setup page" do
        response.should redirect_to 'http://signup.oneclickorgs.com/associations/new'
      end
    end
  end
  
  describe "after app setup" do
    before(:each) do
      Setting[:base_domain] = 'oneclickorgs.com'
      Setting[:signup_domain] = 'signup.oneclickorgs.com'
    end
    
    it "should redirect all setup requests to the homepage" do
      get 'http://oneclickorgs.com/setup'
      response.should redirect_to 'http://oneclickorgs.com/'
    end
    
    it "should redirect all unrecognised subdomain requests back to the new association page" do
      get 'http://nonexistent.oneclickorgs.com/'
      response.should redirect_to 'http://signup.oneclickorgs.com/associations/new'
    end
    
    it "should redirect requests to the root of the signup-domain to the new association page" do
      get 'http://signup.oneclickorgs.com/'
      response.should redirect_to 'http://signup.oneclickorgs.com/associations/new'
    end
    
    describe "visiting the new association page" do
      it "should show a form to set details for the new association" do
        get 'http://signup.oneclickorgs.com/associations/new'
        response.should have_selector("form[action='/associations']") do |form|
          form.should have_selector("input[name='founder[first_name]']")
          form.should have_selector("input[name='founder[last_name]']")
          form.should have_selector("input[name='founder[email]']")
          form.should have_selector("input[name='founder[password]']")
          form.should have_selector("input[name='founder[password_confirmation]']")
          form.should have_selector("input[name='association[name]']")
          form.should have_selector("input[name='association[subdomain]']")
          form.should have_selector("textarea[name='association[objectives]']")
          form.should have_selector("input[type=submit]")
        end
      end
    end
    
    describe "creating a new association" do
      org_parameters = {
        :founder => {
          :first_name => 'Brad',
          :last_name => 'Mehldau',
          :email => 'brad@me.com',
          :password => 'my_password',
          :password_confirmation => 'my_password'
        },
        :association => {
          :name => 'new association',
          :subdomain => 'newassociation',
          :objectives => 'newobjectives',
        }
      }
      it "should create the association record" do
        post 'http://signup.oneclickorgs.com/associations', org_parameters
        Association.where(:subdomain => 'newassociation').first.should_not be_nil
      end
      
      it "should redirect to the induction process for that domain" do
        post 'http://signup.oneclickorgs.com/associations', org_parameters
        response.should redirect_to 'http://newassociation.oneclickorgs.com/constitution'
      end
    end
  end
  
  describe "with multiple organisations" do
    before(:each) do
      set_up_app
      
      # Make three associations, each with one member
      Association.make!(:name => 'Aardvarks', :subdomain => 'aardvarks', :state => 'active').tap do |o|
        mc = o.member_classes.make!
        o.members.make!(:first_name => "Alvin", :email => 'alvin@example.com', :password => 'password', :password_confirmation => 'password', :member_class => mc)
      end
      
      Association.make!(:name => 'Beavers', :subdomain => 'beavers', :state => 'active').tap do |o|
        mc = o.member_classes.make!
        o.members.make!(:first_name => "Betty", :email => 'betty@example.com', :password => 'password', :password_confirmation => 'password', :member_class => mc)
      end
      
      Association.make!(:name => 'Chipmunks', :subdomain => 'chipmunks', :state => 'active').tap do |o|
        mc = o.member_classes.make!
        o.members.make!(:first_name => "Consuela", :email => 'consuela@example.com', :password => 'password', :password_confirmation => 'password', :member_class => mc)
      end
    end
    
    describe "logging in to a subdomain with a correct user" do
      it "should succeed" do
        get 'http://beavers.oneclickorgs.com/'
        response.should redirect_to 'http://beavers.oneclickorgs.com/login'
        post 'http://beavers.oneclickorgs.com/member_session', :email => 'betty@example.com', :password => 'password'
        response.should redirect_to 'http://beavers.oneclickorgs.com/'
        follow_redirect!
        response.body.should =~ /Welcome back, Betty/
      end
    end
    
    describe "logging into a subdomain with a user from a different subdomain" do
      it "should fail" do
        get 'http://aardvarks.oneclickorgs.com/'
        response.should redirect_to 'http://aardvarks.oneclickorgs.com/login'
        post 'http://aardvarks.oneclickorgs.com/member_session', :email => 'consuela@example.com', :password => 'password'
        response.body.should =~ /The email address or password entered were incorrect/
      end
    end
    
    describe "accessing a nonexistent subdomain" do
      it "should redirect to the base domain" do
        get 'http://nonexistent.oneclickorgs.com/'
        response.should redirect_to 'http://signup.oneclickorgs.com/associations/new'
      end
    end
  end
end
