require 'spec_helper'

describe "eject-member proposals" do
  
  before(:each) do
    stub_constitution!
    stub_organisation!
    login
    set_permission!(default_user, :membership_proposal, true)
  end
  
  describe "POST create" do
    before(:each) do
      @member = @organisation.members.make
    end
    
    def post_create
      post('/eject_member_proposals', :eject_member_proposal => {:member_id => @member.id, :description => "Power grab!"})
    end
    
    it "should create the proposal to eject the member" do
      expect{post_create}.to change{@organisation.eject_member_proposals.count}.by(1)
      proposal = @organisation.eject_member_proposals.last
      proposal.member_id.should == @member.id
      proposal.title.should == "Eject #{@member.name} from test"
      proposal.description.should == "Power grab!"
      proposal.proposer.should == @user
    end

    it "should redirect to root" do
      post_create
      @response.should redirect_to('/')
    end
  end

end
