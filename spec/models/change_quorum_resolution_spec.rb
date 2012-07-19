require 'spec_helper'

describe ChangeQuorumResolution do

  describe "attributes" do
    it "has a 'quorum_number' attribute" do
      @change_quorum_resolution = ChangeQuorumResolution.make
      expect {@change_quorum_resolution.quorum_number = 3}.to_not raise_error
      @change_quorum_resolution.quorum_number.should == 3
    end

    it "has a 'quorum_percentage' attribute" do
      @change_quorum_resolution = ChangeQuorumResolution.make
      expect {@change_quorum_resolution.quorum_percentage = 3}.to_not raise_error
      @change_quorum_resolution.quorum_percentage.should == 3
    end
  end

  describe "mass-assignment" do
    it "is allowed for 'quorum_number'" do
      expect {ChangeQuorumResolution.new(:quorum_number => 5)}.to_not raise_error
    end

    it "is allowed for 'quorum_percentage'" do
      expect {ChangeQuorumResolution.new(:quorum_percentage => 5)}.to_not raise_error
    end

    it "is allowed for 'pass_immediately'" do
      expect {ChangeQuorumResolution.new(:pass_immediately => 5)}.to_not raise_error
    end
  end

  it "sets a default title" do
    @resolution = ChangeQuorumResolution.make(:title => nil, :description => nil, :quorum_number => 5, :quorum_percentage => 25)
    @resolution.save!
    @resolution.title.should be_present
    @resolution.title.should include('the greater of 5 members or 25% of the membership')
  end

  describe "enacting" do
    before(:each) do
      @resolution = ChangeQuorumResolution.make!(:quorum_number => 10, :quorum_percentage => 20)
      @resolution.force_passed = true
    end

    it "changes the quorum number" do
      @resolution.organisation.should_receive(:quorum_number=).with(10)
      @resolution.close!
    end

    it "changes the quorum percentage" do
      @resolution.organisation.should_receive(:quorum_percentage=).with(20)
      @resolution.close!
    end
  end

end
