require 'spec_helper'

describe ProposalMailer do
  describe "notify_creation" do

    before do
      default_association_constitution
      default_organisation
      @member = @organisation.members.make!
      @proposal = @organisation.proposals.make!(:proposer_member_id=>@member.id)
    end
    
    it "should include welcome phrase and proposal information in email text" do
      mail = ProposalMailer.notify_creation(@member, @proposal)
      mail.body.should =~ /Dear #{@member.name}/
      mail.body.should =~ /#{@proposal.title}/
      mail.body.should =~ /#{@proposal.description}/            
    end
  
    it "should include correct proposal link in email text" do
      mail = ProposalMailer.notify_creation(@member, @proposal)
      mail.body.should =~ Regexp.new("http://#{@organisation.subdomain}.oneclickorgs.com/proposals/\\d+")
    end
  end
  
  describe "notify_resolution_proposal" do
    before(:each) do
      @resolution_proposal = mock_model(ResolutionProposal,
        :description => "We should hire more chairs for the meetings."
      )
      @secretary = mock_model(Member,
        :name => "Sue Smith"
      )
      
      @organisation = mock_model(Coop,
        :name => "The Digital IPS",
        :domain => "digital.oneclickorgs.com"
      )
      @secretary.stub(:organisation).and_return(@organisation)
      
      @proposer = mock_model(Member,
        :name => "Bob Baker"
      )
      @resolution_proposal.stub(:proposer).and_return(@proposer)
    end
    
    it "includes the proposal description in the email text" do
      mail = ProposalMailer.notify_resolution_proposal(@secretary, @resolution_proposal)
      mail.body.should include(@resolution_proposal.description)
    end
  end
end