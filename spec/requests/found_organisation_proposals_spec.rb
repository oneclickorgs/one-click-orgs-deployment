describe "found organisation proposals" do
  
  before(:each) do 
    default_organisation(:state => 'pending')
    default_constitution
    
    @user = login
    
    set_permission!(@user, :found_organisation_proposal, true)
    
    # Need at least three members to propose foundation
    @organisation.members.make_n(2)
  end
  
  describe "proposing the founding of the organisation" do
    it "should add the proposal" do
      post(found_organisation_proposals_path)
      
      FoundOrganisationProposal.count.should == 1
      FoundOrganisationProposal.first.title.should =~ Regexp.new(@organisation.name)
      FoundOrganisationProposal.first.description.should be_present
    end
  end
  
end
