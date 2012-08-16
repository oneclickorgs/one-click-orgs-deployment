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

  describe "scopes" do
    before(:each) do
      @elected_nomination = Nomination.make!(:state => 'elected')
      @defeated_nomination = Nomination.make!(:state => 'defeated')
    end

    it "has an elected scope" do
      Nomination.elected.should include(@elected_nomination)
      Nomination.elected.should_not include(@defeated_nomination)
    end

    it "has a defeated scope" do
      Nomination.defeated.should include(@defeated_nomination)
      Nomination.defeated.should_not include(@elected_nomination)
    end
  end

  describe "getters" do
    it "gets 'name' from the nominee" do
      @nomination = Nomination.new(:nominee => mock_model(Member, :name => "John Smith"))
      @nomination.name.should == "John Smith"
    end
  end

end
