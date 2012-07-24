require 'spec_helper'

describe Directorship do

  describe "promoting member to director upon save" do
    before(:each) do
      @directorship = Directorship.new

      @organisation = mock_model(Organisation)
      @directorship.stub(:organisation).and_return(@organisation)

      @members_association = mock("members association")
      @organisation.stub(:members).and_return(@members_association)

      @member = mock_model(Member)
      @members_association.stub(:find).and_return(@member)

      @member_classes_association = mock("member classes association")
      @organisation.stub(:member_classes).and_return(@member_classes_association)

      @director_member_class = mock_model(MemberClass)
      @member_classes_association.stub(:find_by_name).and_return(@director_member_class)

      @member.stub(:member_class=)
      @member.stub(:save!)

      @directorship.stub(:member_id).and_return(1)
    end

    it "finds the member" do
      @members_association.should_receive(:find).with(1).and_return(@member)
      @directorship.save!
    end

    it "finds the 'Director' member class" do
      @member_classes_association.should_receive(:find_by_name).with('Director').and_return(@director_member_class)
      @directorship.save!
    end

    it "sets the member's member class to 'Director'" do
      @member.should_receive(:member_class=).with(@director_member_class)
      @directorship.save!
    end

    it "saves the member" do
      @member.should_receive(:save!)
      @directorship.save!
    end
  end

  it "has an 'organisation' attribute" do
    @directorship = Directorship.new
    @organisation = mock_model(Organisation)

    expect {@directorship.organisation = @organisation}.to_not raise_error

    @directorship.organisation.should == @organisation
  end

  describe "member_id attribute" do
    it "accepts a string" do
      @directorship = Directorship.new

      expect {@directorship.member_id = '1'}.to_not raise_error

      @directorship.member_id.should == 1
    end
  end

  it "has a 'certification' attribute" do
    @directorship = Directorship.new
    expect {@directorship.certification = '1'}.to_not raise_error
    @directorship.certification.should == true
  end

  describe "'elected_on' attribute" do
    it "has an 'elected_on' attribute" do
      @directorship = Directorship.new
      expect {@directorship.elected_on = Time.now.utc}.to_not raise_error
      @directorship.elected_on.should be_present
    end

    it "accepts multiparameter attributes" do
      @directorship = Directorship.new

      expect {
        @directorship.attributes = {'elected_on(1i)' => '2012', 'elected_on(2i)' => '7', 'elected_on(3i)' => '23'}
      }.to_not raise_error

      @directorship.elected_on.year.should == 2012
      @directorship.elected_on.month.should == 7
      @directorship.elected_on.day.should == 23
    end
  end

  describe "#persisted?" do
    it "returns false" do
      Directorship.new.persisted?.should be_false
    end
  end
end
