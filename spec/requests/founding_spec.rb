require 'spec_helper'

describe "Founding process" do
  describe "Found Organisation Proposal decision email" do
    before(:each) do
      @organisation = stub_organisation!(false)
      @organisation.pending!
      @founding_member_member_class = @organisation.member_classes.find_by_name("Founding Member")
      @founder_member_class = @organisation.member_classes.find_by_name("Founder")
      @founder = @organisation.members.make(:member_class => @founder_member_class)
      @affirmative_members = [
        @founder,
        @organisation.members.make(:member_class => @founding_member_member_class),
        @organisation.members.make(:member_class => @founding_member_member_class)
      ]
      @negative_members = [
        @organisation.members.make(:member_class => @founding_member_member_class),
        @organisation.members.make(:member_class => @founding_member_member_class)
      ]
      
      @found_organisation_proposal = @organisation.found_organisation_proposals.new(
        :title => "Proposal to found organisation",
        :proposer_member_id => @founder.id
      )
      @found_organisation_proposal.start
      
      @organisation.proposed!
      @organisation.save
      
      @affirmative_members.each do |m|
        m.cast_vote(:for, @found_organisation_proposal)
      end
      @negative_members.each do |m|
        m.cast_vote(:against, @found_organisation_proposal)
      end
      
      ActionMailer::Base.deliveries.clear
    end
    
    it "is sent to the members who voted in favour" do
      @found_organisation_proposal.close!
      
      recipients = ActionMailer::Base.deliveries.map{|email| email.to.first}
      
      @affirmative_members.each do |m|
        # TODO recipients.should.include(m.email) ought to work, but doesn't for some reason
        recipients.include?(m.email).should be_true
      end
    end
    
    it "is sent to the members who voted against" do
      @found_organisation_proposal.close!
      
      recipients = ActionMailer::Base.deliveries.map{|email| email.to.first}
      
      @negative_members.each do |m|
        recipients.include?(m.email).should be_true
      end
    end
  end
end
