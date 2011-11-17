require 'spec_helper'

describe "everything" do
  before(:each) do 
    @user = login
    @proposal = @organisation.proposals.make
    set_permission!(@user, :vote, true)
  end
  
  describe "vote casting" do
    it "should cast a 'for' vote" do
      post(vote_for_path(:id => @proposal.id), {:return_to => '/foo'})
      response.should redirect_to '/foo'
      @proposal.vote_by(@user).for?.should be_true
    end
  
    it "should cast an 'against' vote" do
      post(vote_against_path(:id => @proposal.id), {:return_to => '/foo'})
      response.should redirect_to '/foo'
      @proposal.vote_by(@user).for?.should be_false
    end
  end
  
  describe "vote casting without having permission" do
    before(:each) do 
      set_permission!(@user, :vote, false)
    end

    it "should fail to cast a vote" do
      post(vote_for_path(:id => @proposal.id), {:return_to => '/foo'})
      response.should redirect_to '/'
      @proposal.vote_by(@user).should be_nil
    end
  end
  
  describe "security" do
    it "does not redirect to an external URL if one is passed in the return_to parameter" do
      post(vote_for_path(:id => @proposal.id), {:return_to => 'http://www.evil.com/'})
      response.should redirect_to '/'
    end
  end
end
