require 'rails_helper'

describe "everything" do
  before(:each) do 
    @user = association_login
    @proposal = @organisation.proposals.make!
    set_permission!(@user, :vote, true)
  end
  
  describe "vote casting" do
    it "should cast a 'for' vote" do
      post(vote_for_path(:id => @proposal.id), {:return_to => '/foo'})
      expect(response).to redirect_to '/foo'
      expect(@proposal.vote_by(@user).for?).to be true
    end
  
    it "should cast an 'against' vote" do
      post(vote_against_path(:id => @proposal.id), {:return_to => '/foo'})
      expect(response).to redirect_to '/foo'
      expect(@proposal.vote_by(@user).for?).to be false
    end
  end
  
  describe "vote casting without having permission" do
    before(:each) do 
      set_permission!(@user, :vote, false)
    end

    it "should fail to cast a vote" do
      post(vote_for_path(:id => @proposal.id), {:return_to => '/foo'})
      expect(response).to redirect_to '/'
      expect(@proposal.vote_by(@user)).to be_nil
    end
  end
  
  describe "security" do
    it "does not redirect to an external URL if one is passed in the return_to parameter" do
      post(vote_for_path(:id => @proposal.id), {:return_to => 'http://www.evil.com/'})
      expect(response).to redirect_to '/'
    end
  end
end
