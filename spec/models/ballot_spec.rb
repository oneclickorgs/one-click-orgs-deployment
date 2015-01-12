require 'spec_helper'

describe Ballot do

  describe "ranking" do
    it "has accessors for rankings named by nomination ID" do
      @ballot = Ballot.new
      expect {@ballot.ranking_30}.to_not raise_error
    end

    describe "setting via form parameters" do
      it "accepts rankings named by nomination ID" do
        @ballot = Ballot.new
        expect {@ballot.ranking_30 = '1'}.to_not raise_error
      end

      it "ignores blank rankings" do
        @ballot = Ballot.new
        @ballot.ranking_30 = ''
        expect(@ballot.ranking).to eq([])
      end

      it "constructs a rankings array using rankings passed in by nomination ID" do
        @ballot = Ballot.new
        @ballot.ranking_30 = '1'
        expect(@ballot.ranking).to eq([30])
      end

      it "allows mass-assignment of rankings named by nomination ID" do
        @ballot = Ballot.new
        expect {@ballot.attributes = {'ranking_30' => '1', 'ranking_28' => '2'}}.to_not raise_error
      end
    end

    it "is persisted" do
      @ballot = Ballot.new
      @ballot.ranking = [34, 35, 36]
      @ballot.save!
      @ballot = Ballot.find(@ballot.id)
      expect(@ballot.ranking).to eq([34, 35, 36])
    end
  end

  describe "validations" do
    it "does not allow more than one ballot per member per election"
    it "does not allow gaps in the list of rankings"
    it "does not allow nomination IDs that are not present in the associated election"
  end

  describe "associations" do
    it "belongs to a member" do
      @ballot = Ballot.make!
      @member = Member.make!

      expect {@ballot.member = @member}.to_not raise_error

      @ballot.save!
      @ballot.reload

      expect(@ballot.member(true)).to eq(@member)
    end
  end

end
