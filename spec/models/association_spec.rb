require 'spec_helper'

describe Association do
  
  before(:each) do
    @association = Association.make(:name => 'abc', :objectives => 'To boldly go', :subdomain => 'fromage')
    Setting[:base_domain] = 'oneclickorgs.com'
  end
  
  describe "text fields" do
    before(:each) do
      @association.objectives = 'eat all the cheese' # actually stored as 'organisation_objectives'
      @association.save!
      @association.reload
    end
    
    it "should get the objectives of the organisation" do
      @association.objectives.should == ("eat all the cheese")
    end
    
    it "should change the objectives of the organisation" do
      lambda {
        @association.objectives = "make all the yoghurt"
        @association.save!
        @association.reload
      }.should change(Clause, :count).by(1)
      @association.objectives.should == "make all the yoghurt"
    end
  end
  
  describe "can_hold_founding_vote?" do
    before(:each) do
      @association.members.destroy_all
      @association.members.make_n(3)
      association_is_pending
    end
    
    it "returns false unless the organisation is pending" do
      @association.can_hold_founding_vote?.should be_true
      @association.propose!
      @association.can_hold_founding_vote?.should be_false
    end
    
    it "returns true when there are at least three members" do
      @association.members.destroy_all
      @association.members.make_n(3)
      @association.reload.can_hold_founding_vote?.should be_true
      
      @association.members.destroy_all
      @association.members.make_n(2)
      @association.reload.can_hold_founding_vote?.should be_false
      
      @association.members.destroy_all
      @association.members.make_n(5)
      @association.reload.can_hold_founding_vote?.should be_true
    end
  end
  
  describe "state changes" do
    before(:each) do
      @clauses_association = mock("clauses association", :set_text! => nil)
      @association.stub!(:clauses).and_return(@clauses_association)
    end
    
    describe "#found!" do
      before(:each) do
        @founder_class = mock_model(MemberClass, :name => 'Founder', :description => nil)
        @founding_member_class = mock_model(MemberClass, :name => 'Founding Member', :description => nil)
        
        @member_classes_association = mock("member classes association")
        @member_classes_association.stub!(:find_by_name).with('Founder').and_return(@founder_class)
        @member_classes_association.stub!(:find_by_name).with('Founding Member').and_return(@founding_member_class)
        
        @association.stub!(:member_classes).and_return(@member_classes_association)
        
        association_is_proposed
      end
      
      it "destroys the 'Founder' member class" do
        @founder_class.should_receive(:destroy)
        @association.found!
      end

      it "destroys the 'Founding Member' member class" do
        @founding_member_class.should_receive(:destroy)
        @association.found!
      end

    end
  end
  
end
