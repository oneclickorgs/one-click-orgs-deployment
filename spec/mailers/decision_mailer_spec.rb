require 'spec_helper'

describe DecisionMailer do
  before :each do
    default_constitution
    default_organisation
    @member = @organisation.members.make
    @proposal = @organisation.proposals.make(:proposer_member_id=>@member.id)
    @decision = Decision.make(:proposal=>@proposal)
  end
  
  describe "notify_new_decision" do
    it "should include welcome phrase and proposal information in email text" do
      mail = DecisionMailer.notify_new_decision(@member, @decision)
      mail.body.should =~ /Dear #{@member.name}/
      mail.body.should =~ /a new decision has been made/
      mail.body.should =~ /#{@proposal.title}/
      mail.body.should =~ /#{@proposal.description}/           
    end

    it "should include correct decision link in email text" do
      mail = DecisionMailer.notify_new_decision(@member, @decision)
      mail.body.should =~ Regexp.new("http://#{@organisation.subdomain}.oneclickorgs.com/decisions/\\d+")
    end
  end
  
  context "when proposal has a decision notification message" do
    before(:each) do
      @proposal = @organisation.change_voting_period_proposals.make(:proposer => @member, :parameters => {'new_voting_period' => 3600})
      @decision = Decision.make(:proposal => @proposal)
    end
    
    it "is included in the email" do
      mail = DecisionMailer.notify_new_decision(@member, @decision)
      mail.body.should =~ %r{this prior copy is now out of date}
    end
  end
end
