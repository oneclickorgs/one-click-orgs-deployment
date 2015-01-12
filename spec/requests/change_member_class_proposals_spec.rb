require 'rails_helper'

describe "change member class proposals" do
  before(:each) do
    default_association_constitution
    default_organisation
  end
  
  describe "POST create" do
    before(:each) do
      association_login
      set_permission!(default_association_user, :membership_proposal, true)
      
      @subject_member = @organisation.members.make!
      @new_member_class = @organisation.member_classes.make!
    end
    
    def post_create
      post '/change_member_class_proposals', :change_member_class_proposal => {
        :member_id => @subject_member.id,
        :member_class_id => @new_member_class.id,
        :description => "They deserve this promotion."
      }
    end
    
    describe "saving the proposal" do
      it "creates a new ChangeMemberClassProposal" do
        expect {post_create}.to change{@organisation.change_member_class_proposals.count}.by(1)
      end

      it "makes the current user the proposer of the proposal" do
        post_create
        
        proposal = @organisation.change_member_class_proposals.last
        expect(proposal.proposer).to eq(@user)
      end

      it "sets a default title for the proposal" do
        post_create
        
        proposal = @organisation.change_member_class_proposals.last
        expect(proposal.title).to eq("Change member class of #{@subject_member.name} from #{@subject_member.member_class.name} to #{@new_member_class.name}")
      end
      
      it "saves the submitted proposal parameters" do
        post_create
        
        proposal = @organisation.change_member_class_proposals.last
        expect(proposal.description).to eq("They deserve this promotion.")
        expect(proposal.parameters['member_id']).to eq(@subject_member.id)
        expect(proposal.parameters['member_class_id']).to eq(@new_member_class.id)
      end
    end
    
    it "sets a notice flash" do
      post_create
      expect(flash[:notice]).to be_present
    end
    
    it "redirects to the member page" do
      post_create
      expect(response).to redirect_to("/members/#{@subject_member.to_param}")
    end
  end
  
end
