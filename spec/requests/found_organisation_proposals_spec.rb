describe "found organisation proposals" do
  
  before(:each) do 
    stub_organisation!
    stub_constitution!
    
    @user = login
    
    set_permission!(@user, :found_organisation_proposal, true)
    
    # Need at least three members to propose foundation
    @organisation.members.make_n(2)
    
    @organisation.pending!
  end
  
  describe "proposing the founding of the organisation" do
    it "should add the proposal" do
      post(found_organisation_proposals_path)
      
      FoundOrganisationProposal.count.should == 1
      FoundOrganisationProposal.first.title.should =~ /test/ # The name of the org
      FoundOrganisationProposal.first.description.should be_present
    end
  end
  
end
