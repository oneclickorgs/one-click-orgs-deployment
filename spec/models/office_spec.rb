require 'spec_helper'

describe Office do
  it "has an 'officer' association" do
    @member = Member.make!
    @office = Office.make!
    @officership = Officership.make!(:office => @office, :officer => @member)

    @office.reload

    @office.officer.should == @member
  end

  it "belongs to a coop" do
    @office = Office.make!
    @coop = Coop.make

    expect {@office.organisation = @coop}.to_not raise_error

    @office.organisation.should == @coop
  end
end
