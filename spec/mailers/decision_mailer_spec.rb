require 'rails_helper'

describe DecisionMailer do

  describe "notify_new_decision" do
    before :each do
      default_association_constitution
      default_organisation
      @member = @organisation.members.make!
      @proposal = @organisation.proposals.make!(:proposer_member_id=>@member.id)
      @decision = Decision.make!(:proposal=>@proposal)
    end

    it "should include welcome phrase and proposal information in email text" do
      mail = DecisionMailer.notify_new_decision(@member, @decision)
      expect(mail.body).to match(/Dear #{@member.name}/)
      expect(mail.body).to match(/a new decision has been made/)
      expect(mail.body).to match(/#{@proposal.title}/)
      expect(mail.body).to match(/#{@proposal.description}/)
    end

    it "should include correct decision link in email text" do
      mail = DecisionMailer.notify_new_decision(@member, @decision)
      expect(mail.body).to match(Regexp.new("http://#{@organisation.subdomain}.oneclickorgs.com/decisions/\\d+"))
    end

    context "when proposal has a decision notification message" do
      before(:each) do
        @proposal = @organisation.change_voting_period_proposals.make!(:proposer => @member, :parameters => {'new_voting_period' => 3600})
        @decision = Decision.make!(:proposal => @proposal)
      end

      it "is included in the email" do
        mail = DecisionMailer.notify_new_decision(@member, @decision)
        expect(mail.body).to match(%r{this prior copy is now out of date})
      end
    end
  end

  describe "notify_foundation_decision" do
    before(:each) do
      @active_member = mock_model(Member, :name => "Anna Active")
      @pending_member = mock_model(Member, :name => "Peter Pending")
      @ejected_member = mock_model(Member, :name => "Elizabeth Ejected")
      
      @organisation = mock_model(Organisation, :domain => 'test', :name => nil)
      allow(@organisation).to receive(:members).and_return(@members_association = [
        @active_member,
        @pending_member,
        @ejected_member
      ])
      allow(@members_association).to receive(:active).and_return([@active_member])
      allow(@members_association).to receive(:pending).and_return([@pending_member])

      @user = mock_model(Member, :organisation => @organisation, :votes => [])
      @proposal = mock_model(Proposal,
        :organisation => @organisation,
        :passed? => true,
        :creation_date => 3.days.ago,
        :close_date => 5.minutes.ago,
        :votes_for => 3,
        :votes_against => 0
      )
      @decision = mock_model(Decision, :proposal => @proposal)

      @mail = DecisionMailer.notify_foundation_decision(@user, @decision)
    end

    describe "generating list of members" do
      it "includes the active members" do
        expect(@mail.body).to include(@active_member.name)
      end

      it "includes the pending members" do
        expect(@mail.body).to include(@pending_member.name)
      end

      it "does not include the ejected members" do
        expect(@mail.body).not_to include(@ejected_member.name)
      end
    end
  end

end
