require 'spec_helper'

describe Director do
  
  describe "virtual attributes" do
    it "has a 'certification' attribute" do
      director = Director.new(:certification => '1')
      director.certification.should == '1'
    end
  end
  
  describe "validation" do
    it "validates acceptance of certification"
  end
  
end
