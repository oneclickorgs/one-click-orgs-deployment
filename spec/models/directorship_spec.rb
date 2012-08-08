require 'spec_helper'

describe Directorship do

  describe "saving" do
    before(:each) do
      @directorship = Directorship.new

      @organisation = mock_model(Organisation, :domain => 'tea', :name => 'Tea')
      @directorship.stub(:organisation).and_return(@organisation)

      @director = mock_model(Member, :member_class => nil, :name => "John Smith")
      @directorship.stub(:director).and_return(@director)

      @member_classes_association = mock("member classes association")
      @organisation.stub(:member_classes).and_return(@member_classes_association)

      @director.stub(:member_class=)
      @director.stub(:save!)

      @director_member_class = mock_model(MemberClass)
      @member_classes_association.stub(:find_by_name).with('Director').and_return(@director_member_class)
      @secretary_member_class = mock_model(MemberClass)
      @member_classes_association.stub(:find_by_name).with('Secretary').and_return(@secretary_member_class)
      @member_member_class = mock_model(MemberClass)
      @member_classes_association.stub(:find_by_name).with('Member').and_return(@member_member_class)
    end

    describe "promoting member to director upon save" do
      before(:each) do
        @directorship.elected_on = 1.day.ago
      end

      it "finds the 'Director' member class" do
        @member_classes_association.should_receive(:find_by_name).with('Director').and_return(@director_member_class)
        @directorship.save!
      end

      it "sets the member's member class to 'Director'" do
        @director.should_receive(:member_class=).with(@director_member_class)
        @directorship.save!
      end

      it "saves the member" do
        @director.should_receive(:save!)
        @directorship.save!
      end
    end

    describe "retiring member from directorship upon save" do
      before(:each) do
        @directorship.ended_on = 1.day.ago
      end

      it "sets the member's member class to 'Member'" do
        @director.should_receive(:member_class=).with(@member_member_class)
        @directorship.save!
      end

      it "saves the member" do
        @director.should_receive(:save!)
        @directorship.save!
      end
    end
  end

  it "has an 'organisation' attribute" do
    @directorship = Directorship.new
    @organisation = mock_model(Organisation)

    expect {@directorship.organisation = @organisation}.to_not raise_error

    @directorship.organisation.should == @organisation
  end

  describe "director_id attribute" do
    it "accepts a string" do
      @directorship = Directorship.new

      expect {@directorship.director_id = '1'}.to_not raise_error

      @directorship.director_id.should == 1
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

  describe "'ended_on' attribute" do
    it "has an 'ended_on' attribute" do
      @directorship = Directorship.new
      expect {@directorship.ended_on = Time.now.utc}.to_not raise_error
      @directorship.ended_on.should be_present
    end

    it "accepts multiparameter attributes" do
      @directorship = Directorship.new

      expect {
        @directorship.attributes = {'ended_on(1i)' => '2012', 'ended_on(2i)' => '7', 'ended_on(3i)' => '23'}
      }.to_not raise_error

      @directorship.ended_on.year.should == 2012
      @directorship.ended_on.month.should == 7
      @directorship.ended_on.day.should == 23
    end
  end

end
