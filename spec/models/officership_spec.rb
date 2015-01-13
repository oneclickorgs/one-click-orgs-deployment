require 'rails_helper'

describe Officership do
  describe "attributes" do
    it "has a certification attribute" do
      @officership = Officership.new
      expect {@officership.certification = '0'}.to_not raise_error
      expect(@officership.certification).to be false
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
    expect(@officership.officer).to eq(@member)
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
        expect(@officership.officer).to eq(@member)
      end

      it "sets the office" do
        expect(@officership.office).to eq(@office)
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
        expect(@officership.office).to be_present
        expect(@officership.office).to be_new_record
      end

      it "sets the organisation of the new office to the officer's organisation" do
        @officership.save!
        expect(@officership.office.organisation).to eq(@organisation)
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
        expect(@officership.office.title).to eq("Secretary")
        expect(@officership.office_id).not_to eq(2)
      end

      it "does not amend the existing office" do
        @office.reload
        expect(@office.title).to eq("Treasurer")
      end
    end

    context "when both an existing office ID and blank attributes for a new office are passed" do
      before(:each) do
        @organisation = Coop.make!
        @member = @organisation.members.make!(:id => 1)
        @office = @organisation.offices.make!(:id => 2, :title => "Treasurer")

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
        expect(@officership.office.title).to eq("Treasurer")
        expect(@officership.office_id).to eq(2)
      end

      it "does not amend the existing office" do
        @office.reload
        expect(@office.title).to eq("Treasurer")
      end
    end
  end

  context "when appointing a new Secretary" do
    before(:each) do
      @organisation = Coop.make!
      @member = @organisation.members.make!(:director)
    end

    it "sets the officer's member class to 'Secretary'" do
      @officership = Officership.create!(:officer => @member, :office_attributes => {:title => 'Secretary'})
      expect(@member.member_class(true).name).to eq("Secretary")
    end
  end

  describe "ending" do
    let(:officership) {Officership.make!(ended_on: nil)}

    it "sets the ended_on attribute" do
      officership.end!
      expect(officership.ended_on).to_not be_nil
    end
  end

end
