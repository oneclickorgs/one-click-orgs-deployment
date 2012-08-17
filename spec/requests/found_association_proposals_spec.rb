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

      FoundAssociationProposal.count.should == 1
      FoundAssociationProposal.first.title.should =~ Regexp.new(@organisation.name)
      FoundAssociationProposal.first.description.should be_present
    end
  end

end
