require 'spec_helper'

describe Company do
  
  describe "default member classes" do
    it "creates a 'Director' member class" do
      @company = Company.make
      @company.member_classes.find_by_name('Director').should be_present
    end
  end
  
end
