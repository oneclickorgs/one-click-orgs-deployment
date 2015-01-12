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
      expect(@nomination.nominee(true)).to eq(@nominee)
    end
  end

  describe "scopes" do
    before(:each) do
      @elected_nomination = Nomination.make!(:state => 'elected')
      @defeated_nomination = Nomination.make!(:state => 'defeated')
    end

    it "has an elected scope" do
      expect(Nomination.elected).to include(@elected_nomination)
      expect(Nomination.elected).not_to include(@defeated_nomination)
    end

    it "has a defeated scope" do
      expect(Nomination.defeated).to include(@defeated_nomination)
      expect(Nomination.defeated).not_to include(@elected_nomination)
    end
  end

  describe "getters" do
    it "gets 'name' from the nominee" do
      @nomination = Nomination.new(:nominee => mock_model(Member, :name => "John Smith"))
      expect(@nomination.name).to eq("John Smith")
    end
  end

end
