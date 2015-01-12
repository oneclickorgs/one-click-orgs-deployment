require 'spec_helper'

describe Vote do
  before(:each) do
    @for_vote = Vote.create(:for => true)
    @against_vote = Vote.create(:for => false)
  end
  
  it "should store booleans as an integer" do
    expect(@for_vote.for).to eq(1)
    expect(@against_vote.for).to eq(0)
  end
  
  describe "for_or_against" do
    it "should return 'Support' for a 'for' vote" do
      expect(@for_vote.for_or_against).to eq("Support")
    end
    
    it "should return 'Oppose' for an 'against' vote" do
      expect(@against_vote.for_or_against).to eq("Oppose")
    end
  end
end
