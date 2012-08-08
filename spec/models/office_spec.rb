require 'spec_helper'

describe Office do

  before(:all) do
    ActiveRecord::Base.observers.disable :officership_mailer_observer
  end

  it "has an 'officer' association" do
    @member = Member.make!
    @office = Office.make!
    @officership = Officership.make!(:office => @office, :officer => @member)

    @office.reload

    @office.officer.should == @member
  end

  describe "officership association" do
    it "ignores officerships elected in the future" do
      @office = Office.make!
      @officership = Officership.make!(:office => @office, :elected_on => 1.day.from_now)
      @office.officership.should be_nil
    end

    it "ignores officerships ended in the past" do
      @office = Office.make!
      @officership = Officership.make!(:office => @office, :ended_on => 1.day.ago)
      @office.officership.should be_nil
    end
  end

  it "belongs to a coop" do
    @office = Office.make!
    @coop = Coop.make

    expect {@office.organisation = @coop}.to_not raise_error

    @office.organisation.should == @coop
  end

  after(:all) do
    ActiveRecord::Base.observers.enable :officership_mailer_observer
  end

end
