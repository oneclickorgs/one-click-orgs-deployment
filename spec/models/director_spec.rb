require 'spec_helper'

describe Director do
  
  describe "virtual attributes" do
    it "has a 'certification' attribute" do
      director = Director.new(:certification => '1')
      director.certification.should == '1'
    end
  end
  
  describe "validation" do
    it "validates acceptance of certification on create" do
      director = Director.new(:certification => nil)
      director.should_not be_valid
      director.errors[:certification].should be_present
    end
    
    it "does not validate acceptance of certification on update" do
      director = Director.make!
      director.certification = '0'
      director.should be_valid
    end
  end
  
end
