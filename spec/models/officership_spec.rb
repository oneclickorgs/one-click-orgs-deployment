require 'spec_helper'

describe Officership do
  describe "attributes" do
    it "has a certification attribute" do
      @officership = Officership.new
      expect {@officership.certification = '0'}.to_not raise_error
      @officership.certification.should be_false
    end
  end

  describe "mass-assignment" do
    it "is allowed for 'ended_on'" do
      expect {Officership.new(:ended_on => Date.today)}.to_not raise_error
    end
  end

  it "has an 'officer' association" do
    @officership = Officership.make!
    @member = Member.make!
    expect {@officership.officer = @member}.to_not raise_error
    @officership.save
    @officership.reload
    @officership.officer.should == @member
  end

  describe "creating from params" do
    context "when office already exists" do
      before(:each) do
        @member = Member.make!(:id => 1)
        @office = Office.make!(:id => 2)

        @officership_params = {
          'officer_id' => '1',
          'office_id' => '2',
          'certification' => '1',
          'elected_on(1i)' => '2012',
          'elected_on(2i)' => '7',
          'elected_on(3i)' => '24'
        }
        @officership = Officership.new(@officership_params)
      end

      it "sets the officer" do
        @officership.officer.should == @member
      end

      it "sets the office" do
        @officership.office.should == @office
      end
    end

    context "when office is new" do
      before(:each) do
        @organisation = Coop.make!
        @member = @organisation.members.make!(:id => 1)

        @officership_params = {
          'officer_id' => '1',
          'office_attributes' => {
            'title' => 'Secretary'
          },
          'certification' => '1',
          'elected_on(1i)' => '2012',
          'elected_on(2i)' => '7',
          'elected_on(3i)' => '24'
        }
        @officership = Officership.new(@officership_params)
      end

      it "builds a new office" do
        @officership.office.should be_present
        @officership.office.should be_new_record
      end

      it "sets the organisation of the new office to the officer's organisation" do
        @officership.save!
        @officership.office.organisation.should == @organisation
      end

      it "saves the new office" do
        expect {
          @officership.save!
        }.to change{Office.count}.by(1)
      end
    end

    context "when both an existing office ID and attributes for a new office are passed" do
      before(:each) do
        @organisation = Coop.make!
        @member = @organisation.members.make!(:id => 1)
        @office = Office.make!(:id => 2, :title => "Treasurer")

        @officership_params = {
          'officer_id' => '1',
          'office_id' => '2',
          'office_attributes' => {
            'title' => 'Secretary'
          },
          'certification' => '1',
          'elected_on(1i)' => '2012',
          'elected_on(2i)' => '7',
          'elected_on(3i)' => '24'
        }
        @officership = Officership.new(@officership_params)
      end

      it "prefers the new office" do
        expect {
          @officership.save!
        }.to change{Office.count}.by(1)
        @officership.office.title.should == "Secretary"
        @officership.office_id.should_not == 2
      end

      it "does not amend the existing office" do
        @office.reload
        @office.title.should == "Treasurer"
      end
    end

    context "when both an existing office ID and blank attributes for a new office are passed" do
      before(:each) do
        @organisation = Coop.make!
        @member = @organisation.members.make!(:id => 1)
        @office = Office.make!(:id => 2, :title => "Treasurer")

        @officership_params = {
          'officer_id' => '1',
          'office_id' => '2',
          'office_attributes' => {
            'title' => ''
          },
          'certification' => '1',
          'elected_on(1i)' => '2012',
          'elected_on(2i)' => '7',
          'elected_on(3i)' => '24'
        }
        @officership = Officership.new(@officership_params)
      end

      it "prefers the existing office" do
        expect {
          @officership.save!
        }.to_not change{Office.count}
        @officership.office.title.should == "Treasurer"
        @officership.office_id.should == 2
      end

      it "does not amend the existing office" do
        @office.reload
        @office.title.should == "Treasurer"
      end
    end
  end

end
