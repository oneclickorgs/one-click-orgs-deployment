require 'spec_helper'

describe Association do
  
  before(:each) do
    @association = Association.make!(:name => 'abc', :objectives => 'To boldly go', :subdomain => 'fromage')
    Setting[:base_domain] = 'oneclickorgs.com'
  end
  
  describe "text fields" do
    before(:each) do
      @association.objectives = 'eat all the cheese' # actually stored as 'organisation_objectives'
      @association.save!
      @association.reload
    end
    
    it "should get the objectives of the organisation" do
      expect(@association.objectives).to eq("eat all the cheese")
    end
    
    it "should change the objectives of the organisation" do
      expect {
        @association.objectives = "make all the yoghurt"
        @association.save!
        @association.reload
      }.to change(Clause, :count).by(1)
      expect(@association.objectives).to eq("make all the yoghurt")
    end
  end
  
  describe "can_hold_founding_vote?" do
    before(:each) do
      @association.members.destroy_all
      @association.members.make!(3)
      association_is_pending
    end
    
    it "returns false unless the organisation is pending" do
      expect(@association.can_hold_founding_vote?).to be true
      @association.propose!
      expect(@association.can_hold_founding_vote?).to be false
    end
    
    it "returns true when there are at least three members" do
      @association.members.destroy_all
      @association.members.make!(3)
      expect(@association.reload.can_hold_founding_vote?).to be true
      
      @association.members.destroy_all
      @association.members.make!(2)
      expect(@association.reload.can_hold_founding_vote?).to be false
      
      @association.members.destroy_all
      @association.members.make!(5)
      expect(@association.reload.can_hold_founding_vote?).to be true
    end
  end
  
  describe "state changes" do
    before(:each) do
      @clauses_association = double("clauses association", :set_text! => nil)
      allow(@association).to receive(:clauses).and_return(@clauses_association)
    end
    
    describe "#found!" do
      before(:each) do
        @founder_class = mock_model(MemberClass, :name => 'Founder', :description => nil)
        @founding_member_class = mock_model(MemberClass, :name => 'Founding Member', :description => nil)
        
        @member_classes_association = double("member classes association")
        allow(@member_classes_association).to receive(:find_by_name).with('Founder').and_return(@founder_class)
        allow(@member_classes_association).to receive(:find_by_name).with('Founding Member').and_return(@founding_member_class)
        
        allow(@association).to receive(:member_classes).and_return(@member_classes_association)
        
        association_is_proposed
      end
      
      it "destroys the 'Founder' member class" do
        expect(@founder_class).to receive(:destroy)
        @association.found!
      end

      it "destroys the 'Founding Member' member class" do
        expect(@founding_member_class).to receive(:destroy)
        @association.found!
      end

    end
  end
  
end
