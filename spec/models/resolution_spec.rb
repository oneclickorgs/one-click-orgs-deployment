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
  end
  
end
