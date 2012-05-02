require 'spec_helper'

describe Coop do
  
  describe "being created" do
    it "succeeds" do
      expect {Coop.make!}.to_not raise_error
    end
  end
  
end
