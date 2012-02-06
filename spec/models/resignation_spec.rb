require 'spec_helper'

describe Resignation do
  
  describe "associations" do
    it "belongs to a member" do
      @resignation = Resignation.make
      @member = Member.make
      
      expect {@resignation.member = @member}.to_not raise_error
      
      @resignation.save!
      @resignation.reload
      
      @resignation.member.should == @member
    end
  end
  
  describe '#to_event' do
    before(:each) do
      @resignation = Resignation.make
      @event = @resignation.to_event
    end
    
    it "sets the object field" do
      @event[:object].should == @resignation
    end
    
    it "sets the timestamp field" do
      @event[:timestamp].should == @resignation.created_at
    end
    
    it "sets the kind field" do
      @event[:kind].should == :resignation
    end
  end
  
end
