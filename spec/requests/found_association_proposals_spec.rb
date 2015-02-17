require 'rails_helper'

describe "found association proposals" do

  before(:each) do
    default_association(:state => 'pending')
    default_association_constitution

    @user = association_login

    set_permission!(@user, :found_association_proposal, true)

    # Need at least three members to propose foundation
    @organisation.members.make!(2)
  end

  describe "proposing the founding of the association" do
    it "should add the proposal" do
      post(found_association_proposals_path)

      expect(FoundAssociationProposal.count).to eq(1)
      expect(FoundAssociationProposal.first.title).to match(Regexp.new(@organisation.name))
      expect(FoundAssociationProposal.first.description).to be_present
    end
  end

end
