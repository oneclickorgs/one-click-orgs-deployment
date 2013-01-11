require 'spec_helper'

describe "Association founding process" do
  describe "Found Association Proposal decision email" do
    before(:each) do
      @organisation = default_association(:state => 'pending')
      @founding_member_member_class = @organisation.member_classes.find_by_name("Founding Member")
      @founder_member_class = @organisation.member_classes.find_by_name("Founder")
      @founder = @organisation.members.make!(:member_class => @founder_member_class, :state => 'pending')
      @affirmative_members = [
        @founder,
        @organisation.members.make!(:member_class => @founding_member_member_class, :state => 'pending'),
        @organisation.members.make!(:member_class => @founding_member_member_class, :state => 'pending')
      ]
      @negative_members = [
        @organisation.members.make!(:member_class => @founding_member_member_class, :state => 'pending'),
        @organisation.members.make!(:member_class => @founding_member_member_class, :state => 'pending')
      ]

      @found_association_proposal = @organisation.found_association_proposals.new(
        :title => "Proposal to found association",
        :proposer_member_id => @founder.id
      )
      @found_association_proposal.save

      @organisation.propose!
      @found_association_proposal.reload

      @affirmative_members.each do |m|
        m.cast_vote(:for, @found_association_proposal)
      end
      @negative_members.each do |m|
        m.cast_vote(:against, @found_association_proposal)
      end

      ActionMailer::Base.deliveries.clear
    end

    it "is sent to the members who voted in favour" do
      @found_association_proposal.close!

      recipients = ActionMailer::Base.deliveries.map{|email| email.to.first}

      @affirmative_members.each do |m|
        # TODO recipients.should.include(m.email) ought to work, but doesn't for some reason
        recipients.include?(m.email).should be_true
      end
    end

    it "is sent to the members who voted against" do
      @found_association_proposal.close!

      recipients = ActionMailer::Base.deliveries.map{|email| email.to.first}

      @negative_members.each do |m|
        recipients.include?(m.email).should be_true
      end
    end
  end
end
