require 'spec_helper'

describe Nomination do

  describe "associations" do
    it "belongs to a nominee" do
      @nomination = Nomination.make!
      @nominee = Member.make!

      expect {@nomination.nominee = @nominee}.to_not raise_error

      @nomination.save!
      @nomination.reload

      # Passing true forces a reload of the association
      @nomination.nominee(true).should == @nominee
    end
  end

  describe "getters" do
    it "gets 'name' from the nominee" do
      @nomination = Nomination.new(:nominee => mock_model(Member, :name => "John Smith"))
      @nomination.name.should == "John Smith"
    end
  end

end
