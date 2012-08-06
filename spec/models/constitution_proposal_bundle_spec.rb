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
    let(:secretary) {organisation.members.make!(:secretary)}

    let(:change_text_resolutions) {mock("change_text_resolutions association")}

    let(:cpb) {organisation.build_constitution_proposal_bundle(cpb_params)}

    def change_text_resolution
      mock_model(ChangeTextResolution, :proposer= => nil, :save! => true)
    end

    before(:each) do
      cpb.proposer = secretary
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

end
