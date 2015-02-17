require 'rails_helper'

describe "eject-member proposals" do
  
  before(:each) do
    default_association_constitution
    default_organisation
    association_login
    set_permission!(default_association_user, :membership_proposal, true)
  end
  
  describe "POST create" do
    before(:each) do
      @member = @organisation.members.make!
    end
    
    def post_create
      post('/eject_member_proposals', :eject_member_proposal => {:member_id => @member.id, :description => "Power grab!"})
    end
    
    it "should create the proposal to eject the member" do
      expect{post_create}.to change{@organisation.eject_member_proposals.count}.by(1)
      proposal = @organisation.eject_member_proposals.last
      expect(proposal.member_id).to eq(@member.id)
      expect(proposal.title).to eq("Eject #{@member.name} from #{@organisation.name}")
      expect(proposal.description).to eq("Power grab!")
      expect(proposal.proposer).to eq(@user)
    end

    it "should redirect to root" do
      post_create
      expect(@response).to redirect_to('/')
    end
  end

end
