require 'spec_helper'

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
        cpb.save.should be_true
      end

      it "builds draft resolutions" do
        cpb.organisation.stub(:change_text_resolutions).and_return(change_text_resolutions)

        change_text_resolutions.should_receive(:build).with(hash_including(:draft => true)).at_least(:once).and_return(change_text_resolution)

        cpb.save
      end

      it "builds a change_text resolution for the organisation name" do
        expect {cpb.save}.to change{ChangeTextResolution.count}
        ChangeTextResolution.where(['parameters LIKE ?', "%organisation_name%"]).should be_present
      end

      it "builds a change_text resolution for the registered office address" do
        expect {cpb.save}.to change{ChangeTextResolution.count}
        ChangeTextResolution.where(['parameters LIKE ?', "%registered_office_address%"]).should be_present
      end

      it "builds a change_text resolution for the objectives" do
        expect {cpb.save}.to change{ChangeTextResolution.count}
        ChangeTextResolution.where(['parameters LIKE ?', "%organisation_objectives%"]).should be_present
      end

      it "builds change_boolean resolutions for the member types" do
        expect {cpb.save}.to change{ChangeBooleanResolution.count}
        ChangeBooleanResolution.where(['parameters LIKE ?', "%supporter_members%"]).should be_present
        ChangeBooleanResolution.where(['parameters LIKE ?', "%producer_members%"]).should be_present
        ChangeBooleanResolution.where(['parameters LIKE ?', "%consumer_members%"]).should be_present
      end

      it "builds a change_boolean resolution for the shareholding" do
        expect {cpb.save}.to change{ChangeBooleanResolution.count}
        ChangeBooleanResolution.where(['parameters LIKE ?', "%single_shareholding%"]).should be_present
      end

      it "builds change_integer resolutions for the board compositions" do
        expect {cpb.save}.to change{ChangeIntegerResolution.count}
        ChangeIntegerResolution.where(['parameters LIKE ?', "%max_user_directors%"]).should be_present
        ChangeIntegerResolution.where(['parameters LIKE ?', "%max_employee_directors%"]).should be_present
        ChangeIntegerResolution.where(['parameters LIKE ?', "%max_supporter_directors%"]).should be_present
        ChangeIntegerResolution.where(['parameters LIKE ?', "%max_producer_directors%"]).should be_present
        ChangeIntegerResolution.where(['parameters LIKE ?', "%max_consumer_directors%"]).should be_present
      end

      it "builds a change_boolean resolution for the ownership type" do
        expect {cpb.save}.to change{ChangeBooleanResolution.count}
        ChangeBooleanResolution.where(['parameters LIKE ?', "%common_ownership%"]).should be_present
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
        cpb.save.should be_true
      end

      it "builds resolution proposals" do
        cpb.organisation.stub(:resolution_proposals).and_return(resolution_proposals)

        resolution_proposals.should_receive(:build).with(hash_including(:resolution_class => "ChangeTextResolution")).at_least(:once).and_return(resolution_proposal)

        cpb.save
      end

      it "builds a change_text resolution_proposal for the organisation name" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%'").count}
        ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%' AND parameters LIKE '%organisation_name%'").should be_present
      end

      it "builds a change_text resolution_proposal for the registered office address" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%'").count}
        ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%' AND parameters LIKE '%registered_office_address%'").should be_present
      end

      it "builds a change_text resolution_proposal for the objectives" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%'").count}
        ResolutionProposal.where("parameters LIKE '%ChangeTextResolution%' AND parameters LIKE '%organisation_objectives%'").should be_present
      end

      it "builds change_boolean resolution_proposals for the member types" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%'").count}
        ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%' AND parameters LIKE '%supporter_members%'").should be_present
        ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%' AND parameters LIKE '%producer_members%'").should be_present
        ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%' AND parameters LIKE '%consumer_members%'").should be_present
      end

      it "builds a change_boolean resolution_proposals for the shareholding" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%'").count}
        ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%' AND parameters LIKE '%single_shareholding%'").should be_present
      end

      it "builds change_integer resolutions for the board compositions" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%'").count}
        ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%' AND parameters LIKE '%max_user_directors%'").should be_present
        ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%' AND parameters LIKE '%max_employee_directors%'").should be_present
        ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%' AND parameters LIKE '%max_supporter_directors%'").should be_present
        ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%' AND parameters LIKE '%max_producer_directors%'").should be_present
        ResolutionProposal.where("parameters LIKE '%ChangeIntegerResolution%' AND parameters LIKE '%max_consumer_directors%'").should be_present
      end

      it "builds a change_boolean resolution for the ownership type" do
        expect {cpb.save}.to change{ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%'").count}
        ResolutionProposal.where("parameters LIKE '%ChangeBooleanResolution%' AND parameters LIKE '%common_ownership%'").should be_present
      end
    end
  end

end
