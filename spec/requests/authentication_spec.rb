require 'rails_helper'

describe "authentication" do
  before(:each) do
    default_association_user
  end
  
  describe "getting login form" do
    it "should display a login form" do
      get '/login'
      expect(response).to have_selector("form[action='/member_session']")
    end
  end
  
  describe "logging in" do
    before(:each) do
      post member_session_path, :email => @default_user.email, :password => 'password'
    end
    
    it "should log in the user" do
      expect(session[:user]).to eq(Member.last.id)
    end
    
    it "should redirect to the home page" do
      expect(response).to redirect_to('/')
    end
  end
  
  describe "trying to log in with bad credentials" do
    before(:each) do
      post member_session_path, :email => @default_user.email, :password => 'wrongpassword'
    end
    
    it "should not log in the user" do
      expect(session[:user]).to be_nil
    end
    
    it "should render the login form" do
      expect(response).to have_selector("form[action='/member_session']")
    end
    
    it "should set an error flash" do
      expect(flash[:error]).not_to be_blank
    end
  end
  
  describe "logging out" do
    before(:each) do
      post member_session_path, :email => @default_user.email, :password => 'password'
      delete member_session_path
    end
    
    it "should log out the user" do
      expect(session[:user]).to be_nil
    end
    
    it "should redirect to the home page" do
      expect(response).to redirect_to('/')
    end
  end
end
