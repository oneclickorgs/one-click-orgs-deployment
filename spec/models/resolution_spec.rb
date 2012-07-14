require 'spec_helper'

describe Resolution do
  
  describe "draft status" do
    describe "being set on creation" do
      it "sets its state to 'draft'" do
        @resolution = Resolution.make!(:draft => true)
        @resolution[:state].should == 'draft'
      end
      
      it "does not set the close date" do
        @resolution = Resolution.make!(:draft => true)
        @resolution.close_date.should be_nil
      end
    end
    
    describe "starting from draft state" do
      it "sets the close date" do
        @resolution = Resolution.make!(:draft => true)
        @resolution.start!
        @resolution.close_date.should be_present
      end
    end
    
    it "understands '1' and '0' as boolean values" do
      @resolution = Resolution.make
      
      @resolution.draft = '1'
      @resolution.draft.should == true
      
      @resolution.draft = '0'
      @resolution.draft.should == false
    end
  end
  
  describe "automatic title" do
    it "automatically sets the title based on the description" do
      @resolution = Resolution.make(:title => nil, :description => "A description of the resolution")
      @resolution.save!
      @resolution.title.should be_present
    end
  end
  
  describe "mass assignment" do
    it "is allowed for 'draft'" do
      expect {Resolution.new(:draft => true)}.to_not raise_error
    end
    
    it "is allowed for 'voting_period_in_days'" do
      expect {Resolution.new(:voting_period_in_days => 14)}.to_not raise_error
    end
    
    it "is allowed for 'extraordinary'" do
      expect {Resolution.new(:extraordinary => true)}.to_not raise_error
    end
    
    it "is allowed for 'certification'" do
      expect {Resolution.new(:certification => true)}.to_not raise_error
    end
  end
  
end
