require 'spec_helper'

describe GeneralMeeting do

  describe "mass assignment" do
    it "allows mass-assignment of 'existing_resolutions_attributes'" do
      expect{GeneralMeeting.new(:existing_resolutions_attributes => "something")}.to_not raise_error
    end
  end

  describe "associations" do
    it "has many resolutions" do
      @general_meeting = GeneralMeeting.make!
      @resolution = Resolution.make!

      expect{@general_meeting.resolutions << @resolution}.to_not raise_error

      @general_meeting.reload
      @general_meeting.resolutions.reload

      expect(@general_meeting.resolutions).to include(@resolution)
    end
  end

  describe "attributes" do
    it "has an 'annual_general_meeting' attribute" do
      expect{GeneralMeeting.new(:annual_general_meeting => '1')}.to_not raise_error
    end

    it "has an electronic_nominations attribute" do
      expect{GeneralMeeting.new.electronic_nominations}.to_not raise_error
    end

    it "has a nominations_closing_date attribute" do
      expect{GeneralMeeting.new.nominations_closing_date}.to_not raise_error
    end
  end

  describe "setting existing resolutions" do
    before(:each) do
      @existing_resolutions_attributes = {"0"=>{"attached"=>"1", "id"=>"7"}, "1"=>{"attached"=>"0", "id"=>"9"}}

      @meeting = GeneralMeeting.new

      allow(Resolution).to receive(:find_by_id).with(7).and_return(@resolution_7 = mock_model(Resolution, :draft? => true, :attach! => nil, :id => 7))
      allow(Resolution).to receive(:find_by_id).with(9).and_return(@resolution_9 = mock_model(Resolution, :draft? => true, :attach! => nil, :id => 9))
    end

    it "adds the attached resolutions to the 'resolutions' association" do
      @meeting.existing_resolutions_attributes = @existing_resolutions_attributes

      expect(@meeting.resolutions.length).to eq 1
      expect(@meeting.resolutions).to include(@resolution_7)
      expect(@meeting.resolutions).not_to include(@resolution_9)
    end

    it "moves the resolutions to the 'attached' state" do
      expect(@resolution_7).to receive(:attach!)
      expect(@resolution_9).not_to receive(:attach!)

      @meeting.existing_resolutions_attributes = @existing_resolutions_attributes
    end

    context "when a resolution marked as to be opened for electronic voting" do
      before(:each) do
        @existing_resolutions_attributes = {
          "0"=>{"attached"=>"1", "id"=>"7", "open"=>"1"},
          "1"=>{"attached"=>"0", "id"=>"9", "open"=>"0"}
        }
      end

      it "moves the resolution to the 'open' state" do
        expect(@resolution_7).to receive(:start!)
        expect(@resolution_7).not_to receive(:attach!)

        @meeting.existing_resolutions_attributes = @existing_resolutions_attributes
      end
    end
  end

  describe "setting passed resolutions" do
    let(:meeting) {GeneralMeeting.make}
    let(:resolutions) {[
      mock_model(Resolution),
      mock_model(Resolution)
    ]}

    before(:each) do
      allow(meeting).to receive(:resolutions).and_return(resolutions)
      allow(resolutions).to receive(:find_by_id).with(7).and_return(resolutions[0])
      allow(resolutions).to receive(:find_by_id).with(9).and_return(resolutions[1])
    end

    it "it forces the passed resolutions to pass" do
      expect(resolutions[0]).to receive(:force_passed=).with(true)

      meeting.passed_resolutions_attributes = {"0"=>{"passed"=>"1", "id"=>"7"}, "1"=>{"passed"=>"0", "id"=>"9"}}

      expect(resolutions[0]).to receive(:close!)

      meeting.save!
    end
  end

  describe "recording vote counts from the meeting for proposals with electronic voting" do
    let(:meeting) {GeneralMeeting.make!}
    let(:resolution) {mock_model(Resolution,
      :close! => nil,
      :save! => true,
      :additional_votes_for= => nil,
      :additional_votes_against= => nil
    )}
    let(:passed_resolutions_attributes) {{'1' => {
        'id' => '1', 'passed' => '0',
        'additional_votes_for' => '3', 'additional_votes_against' => '1'}
    }}
    let(:resolutions) {double("resolutions", :find_by_id => resolution)}

    before(:each) do
      allow(meeting).to receive(:resolutions).and_return(resolutions)
    end

    it "updates the vote counts in the resolution records" do
      expect(resolution).to receive(:additional_votes_for=).with(3)
      expect(resolution).to receive(:additional_votes_against=).with(1)
      expect(resolution).to receive(:save!)

      meeting.passed_resolutions_attributes = passed_resolutions_attributes
      meeting.save!
    end

    it "it closes the proposals" do
      expect(resolution).to receive(:close!)

      meeting.passed_resolutions_attributes = passed_resolutions_attributes
      meeting.save!
    end
  end

  it "should not send a 'new minutes' email upon creation"

  describe "tasks" do
    describe "on creation" do
      it "creates a future task for the Secretary to minute the meeting" do
        meeting_date = 2.weeks.from_now
        meeting = GeneralMeeting.make(:happened_on => meeting_date, :minutes => nil)

        secretary = mock_model(Member)
        allow(meeting.organisation).to receive(:secretary).and_return(secretary)

        tasks_association = double("tasks association")
        allow(secretary).to receive(:tasks).and_return(tasks_association)

        expect(tasks_association).to receive(:create).with(hash_including(
          :subject => meeting,
          :action => :minute,
          :starts_on => meeting_date
        ))

        meeting.save!
      end
    end
  end

  describe "agenda items" do
    context "when building a new GeneralMeeting" do
      it "builds defaults" do
        meeting = GeneralMeeting.new
        expect(meeting.agenda_items.map(&:title)).to eq [
          "Apologies for Absence",
          "Minutes of Previous Meeting",
          "Any Other Business",
          "Time and date of next meeting"
        ]
      end
    end
  end

  it "accepts multi-parameter attributes for start_time via start_time_proxy" do
    begin
      meeting = GeneralMeeting.new
      # Multi-parameter assignment expects date components, even if they are not used
      meeting.attributes = {
        'start_time_proxy(1i)' => '2012',
        'start_time_proxy(2i)' => '10',
        'start_time_proxy(3i)' => '14',
        'start_time_proxy(4i)' => '16',
        'start_time_proxy(5i)' => '45'
      }
      expect(meeting.start_time).to eq('16:45')
    rescue ActiveRecord::MultiparameterAssignmentErrors => mae
      raise mae.errors.map{|e| "#{e.attribute}: #{e.exception}"}.inspect + mae.backtrace.inspect
    end
  end

end
