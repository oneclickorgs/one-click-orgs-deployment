require 'spec_helper'

describe Organisation do
  before(:each) do
    @organisation = Organisation.make(:name => 'abc', :objectives => 'To boldly go', :subdomain => 'fromage')
    Setting[:base_domain] = 'oneclickorgs.com'
  end
  
  describe "validation" do
    it "should not allow multiple organisations with the same subdomain" do
      @first = Organisation.make(:name => 'abc', :objectives => 'To boldly go', :subdomain => "apples")

      lambda do
        @second = Organisation.make(:name => 'def', :objectives => 'To boldly go', :subdomain => "apples")
      end.should raise_error(ActiveRecord::RecordInvalid)
    end
  end
  
  describe "text fields" do
    before(:each) do
      @organisation.name = 'The Cheese Collective' # actually stored as 'organisation_name'
      @organisation.objectives = 'eat all the cheese' # actually stored as 'organisation_objectoves'
      @organisation.save!
      @organisation.reload
    end
    
    it "should get the name of the organisation" do
      @organisation.name.should == ("The Cheese Collective")
    end

    it "should get the objectives of the organisation" do
      @organisation.objectives.should == ("eat all the cheese")
    end
    
    it "should change the name of the organisation" do
      lambda {
        @organisation.name = "The Yoghurt Yurt"
        @organisation.save!
        @organisation.reload
      }.should change(Clause, :count).by(1)
      @organisation.name.should == "The Yoghurt Yurt"
    end
    
    it "should change the objectives of the organisation" do
      lambda {
        @organisation.objectives = "make all the yoghurt"
        @organisation.save!
        @organisation.reload
      }.should change(Clause, :count).by(1)
      @organisation.objectives.should == "make all the yoghurt"
    end
  end
  
  describe "domain" do
    it "should return the root URL for this organisation" do
      @organisation.domain.should == "http://fromage.oneclickorgs.com"
    end
    
    context "with only_host option true" do
      it "should remove the http://" do
        @organisation.domain(:only_host => true).should == "fromage.oneclickorgs.com"
      end
    end
  end
  
  describe "can_hold_founding_vote?" do
    before(:each) do
      @organisation.members.destroy_all
      @organisation.members.make_n(3)
      organisation_is_pending
    end
    
    it "returns false unless the organisation is pending" do
      @organisation.can_hold_founding_vote?.should be_true
      @organisation.propose!
      @organisation.can_hold_founding_vote?.should be_false
    end
    
    it "returns true when there are at least three members" do
      @organisation.members.destroy_all
      @organisation.members.make_n(3)
      @organisation.reload.can_hold_founding_vote?.should be_true
      
      @organisation.members.destroy_all
      @organisation.members.make_n(2)
      @organisation.reload.can_hold_founding_vote?.should be_false
      
      @organisation.members.destroy_all
      @organisation.members.make_n(5)
      @organisation.reload.can_hold_founding_vote?.should be_true
    end
  end
  
  describe "state changes" do
    before(:each) do
      @clauses_association = mock("clauses association", :set_text! => nil)
      @organisation.stub!(:clauses).and_return(@clauses_association)
    end
    
    describe "#found!" do
      before(:each) do
        @founder_class = mock_model(MemberClass, :name => 'Founder', :description => nil)
        @founding_member_class = mock_model(MemberClass, :name => 'Founding Member', :description => nil)
        
        @member_classes_association = mock("member classes association")
        @member_classes_association.stub!(:find_by_name).with('Founder').and_return(@founder_class)
        @member_classes_association.stub!(:find_by_name).with('Founding Member').and_return(@founding_member_class)
        
        @organisation.stub!(:member_classes).and_return(@member_classes_association)
        
        organisation_is_proposed
      end
      
      it "destroys the 'Founder' member class" do
        @founder_class.should_receive(:destroy)
        @organisation.found!
      end

      it "destroys the 'Founding Member' member class" do
        @founding_member_class.should_receive(:destroy)
        @organisation.found!
      end

    end
  end
end
