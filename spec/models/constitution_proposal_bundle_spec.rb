require 'rails_helper'

describe ConstitutionProposalBundle do

  context "when organisation is a Coop" do
    let(:cpb_params) {{
      "organisation_name" => "The Tea Co-op",
      "registered_office_address" => "1 Main Street",
      "objectives" => "buy all the tea.",
      "user_members" => "1",
      "employee_members" => "1",
      "supporter_members" => "0",
      "producer_members" => "0",
      "consumer_members" => "0",
      "single_shareholding" => "1",
      "max_user_directors" => "2",
      "max_employee_directors" => "2",
      "max_supporter_directors" => "2",
      "max_producer_directors" => "2",
      "max_consumer_directors" => "2",
      "common_ownership" => "1"
    }}

    let(:organisation) {Coop.make!}

    let(:cpb) {organisation.build_constitution_proposal_bundle(cpb_params)}

    context "when proposer is the secretary" do
      let(:secretary) {organisation.members.make!(:secretary)}
      let(:change_text_resolutions) {double("change_text_resolutions association")}

      before(:each) do
        cpb.proposer = secretary
      end

      def change_text_resolution
        mock_model(ChangeTextResolution, :proposer= => nil, :save! => true)
      end

      it "saves successfully" do
        expect(cpb.save).to be true
      end

      it "builds draft resolutions" do
        allow(cpb.organisation).to receive(:change_text_resolutions).and_return(change_text_resolutions)

        expect(change_text_resolutions).to receive(:build).with(hash_including(:draft => true)).at_least(:once).and_return(change_text_resolution)

        cpb.save
      end

      it "builds a change_text resolution for the organisation name" do
        expect {cpb.save}.to change{ChangeTextResolution.count}
        expect(ChangeTextResolution.where(['parameters LIKE ?', "%organisation_name%"])).to be_present
      end

      it "builds a change_text resolution for the registered office address" do
        expect {cpb.save}.to change{ChangeTextResolution.count}
        expect(ChangeTextResolution.where(['parameters LIKE ?', "%registered_office_address%"])).to be_present
      end

      it "builds a change_text resolution for the objectives" do
        expect {cpb.save}.to change{ChangeTextResolution.count}
        expect(ChangeTextResolution.where(['parameters LIKE ?', "%organisation_objectives%"])).to be_present
      end

      it "builds change_boolean resolutions for the member types" do
        expect {cpb.save}.to change{ChangeBooleanResolution.count}
        expect(ChangeBooleanResolution.where(['parameters LIKE ?', "%supporter_members%"])).to be_present
        expect(ChangeBooleanResolution.where(['parameters LIKE ?', "%producer_members%"])).to be_present
        expect(ChangeBooleanResolution.where(['parameters LIKE ?', "%consumer_members%"])).to be_present
      end

      it "builds a change_boolean resolution for the shareholding" do
        expect {cpb.save}.to change{ChangeBooleanResolution.count}
        expect(ChangeBooleanResolution.where(['parameters LIKE ?', "%single_shareholding%"])).to be_present
      end

      it "builds change_integer resolutions for the board compositions" do
        expect {cpb.save}.to change{ChangeIntegerResolution.count}
        expect(ChangeIntegerResolution.where(['parameters LIKE ?', "%max_user_directors%"])).to be_present
        expect(ChangeIntegerResolution.where(['parameters LIKE ?', "%max_employee_directors%"])).to be_present
        expect(ChangeIntegerResolution.where(['parameters LIKE ?', "%max_supporter_directors%"])).to be_present
        expect(ChangeIntegerResolution.where(['parameters LIKE ?', "%max_producer_directors%"])).to be_present
        expect(ChangeIntegerResolution.where(['parameters LIKE ?', "%max_consumer_directors%"])).to be_present
      end

      it "builds a change_boolean resolution for the ownership type" do
        expect {cpb.save}.to change{ChangeBooleanResolution.count}
        expect(ChangeBooleanResolution.where(['parameters LIKE ?', "%common_ownership%"])).to be_present
      end
    end


    context "when proposer can only create ResolutionProposals" do
      let(:member) {organisation.members.make!(:member)}
      let(:resolution_proposals) {double("resolution_proposals association", :build => resolution_proposal)}

      before(:each) do
        cpb.proposer = member
      end

      def resolution_proposal
        mock_model(ResolutionProposal, :proposer= => nil, :save! => true)
      end

      it "saves successfully" do
        expect(cpb.save).to be true
      end

      it "builds resolution proposals" do
        allow(cpb.organisation).to receive(:resolution_proposals).and_return(resolution_proposals)

        expect(resolution_proposals).to receive(:build).with(hash_including(:resolution_class => "ChangeTextResolution")).at_least(:once).and_return(resolution_proposal)

        cpb.save
      end

      it "builds a change_text resolution_proposal for the organisation name" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%'").count}
        expect(ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%' AND parameters LIKE '%organisation_name%'")).to be_present
      end

      it "builds a change_text resolution_proposal for the registered office address" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%'").count}
        expect(ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%' AND parameters LIKE '%registered_office_address%'")).to be_present
      end

      it "builds a change_text resolution_proposal for the objectives" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%'").count}
        expect(ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%' AND parameters LIKE '%organisation_objectives%'")).to be_present
      end

      it "builds change_boolean resolution_proposals for the member types" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%'").count}
        expect(ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%' AND parameters LIKE '%supporter_members%'")).to be_present
        expect(ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%' AND parameters LIKE '%producer_members%'")).to be_present
        expect(ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%' AND parameters LIKE '%consumer_members%'")).to be_present
      end

      it "builds a change_boolean resolution_proposals for the shareholding" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%'").count}
        expect(ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%' AND parameters LIKE '%single_shareholding%'")).to be_present
      end

      it "builds change_integer resolutions for the board compositions" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%'").count}
        expect(ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%' AND parameters LIKE '%max_user_directors%'")).to be_present
        expect(ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%' AND parameters LIKE '%max_employee_directors%'")).to be_present
        expect(ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%' AND parameters LIKE '%max_supporter_directors%'")).to be_present
        expect(ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%' AND parameters LIKE '%max_producer_directors%'")).to be_present
        expect(ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%' AND parameters LIKE '%max_consumer_directors%'")).to be_present
      end

      it "builds a change_boolean resolution for the ownership type" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%'").count}
        expect(ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%' AND parameters LIKE '%common_ownership%'")).to be_present
      end
    end
  end

end
