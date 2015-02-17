require 'rails_helper'

module ProposalsSpecHelper
  def a_proposal_exists
    Proposal.destroy_all
    user = association_login
    
    set_permission!(user, :freeform_proposal, true)
    post(proposals_path, {:proposal => {:id => nil, :proposer_member_id => user.id, :title => 'proposal'}})
    @proposal = Proposal.first or raise "cannot create proposal"
  end
end

describe "Proposals" do

  include RequestSpecHelper
  include ProposalsSpecHelper
  
  before(:each) do 
    default_association
    default_association_constitution
    
    @user = association_login
  end
  
  describe "/proposals/1, given a proposal exists" do
    before(:each) do
      set_permission!(@user, :vote, true)
      @member_two = @organisation.members.make!(:member_class => @default_member_class)
      set_permission!(@member_two, :vote, true)
      @member_three = @organisation.members.make!(:member_class => @default_member_class)
      set_permission!(@member_two, :vote, true)
      
      a_proposal_exists
    end
    
    describe "GET" do
      before(:each) do
        @proposal = Proposal.first
        @member_two.cast_vote(:for, @proposal)
        @member_three.cast_vote(:against, @proposal)

        get(proposal_path(@proposal))
      end
  
      it "responds successfully" do
        expect(@response).to be_successful
      end
    end
  end
  
  describe "/proposals, given a proposal exists"  do
    before(:each) do
      a_proposal_exists
    end
    
     describe "GET" do
       before(:each) do
         get(proposals_path)
       end

       it "responds successfully" do
         expect(@response).to be_successful
       end

       it "contains a list of proposals" do
         # pending
         expect(page).to have_xpath("//ul")
       end
     end
  end
end
