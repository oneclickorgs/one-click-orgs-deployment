require 'spec_helper'

describe Resignation do
  
  describe "associations" do
    it "belongs to a member" do
      @resignation = Resignation.make!
      @member = Member.make!
      
      expect {@resignation.member = @member}.to_not raise_error
      
      @resignation.save!
      @resignation.reload
      
      expect(@resignation.member).to eq(@member)
    end
  end
  
  describe '#to_event' do
    before(:each) do
      @resignation = Resignation.make!
      @event = @resignation.to_event
    end
    
    it "sets the object field" do
      expect(@event[:object]).to eq(@resignation)
    end
    
    it "sets the timestamp field" do
      expect(@event[:timestamp]).to eq(@resignation.created_at)
    end
    
    it "sets the kind field" do
      expect(@event[:kind]).to eq(:resignation)
    end
  end
  
end
