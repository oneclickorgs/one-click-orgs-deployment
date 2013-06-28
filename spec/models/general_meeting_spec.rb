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

      @general_meeting.resolutions.should include(@resolution)
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

      Resolution.stub(:find_by_id).with(7).and_return(@resolution_7 = mock_model(Resolution, :draft? => true, :attach! => nil, :id => 7))
      Resolution.stub(:find_by_id).with(9).and_return(@resolution_9 = mock_model(Resolution, :draft? => true, :attach! => nil, :id => 9))
    end

    it "adds the attached resolutions to the 'resolutions' association" do
      @meeting.existing_resolutions_attributes = @existing_resolutions_attributes

      @meeting.resolutions.length.should eq 1
      @meeting.resolutions.should include(@resolution_7)
      @meeting.resolutions.should_not include(@resolution_9)
    end

    it "moves the resolutions to the 'attached' state" do
      @resolution_7.should_receive(:attach!)
      @resolution_9.should_not_receive(:attach!)

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
        @resolution_7.should_receive(:start!)
        @resolution_7.should_not_receive(:attach!)

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
      meeting.stub(:resolutions).and_return(resolutions)
      resolutions.stub(:find_by_id).with(7).and_return(resolutions[0])
      resolutions.stub(:find_by_id).with(9).and_return(resolutions[1])
    end

    it "it forces the passed resolutions to pass" do
      resolutions[0].should_receive(:force_passed=).with(true)

      meeting.passed_resolutions_attributes = {"0"=>{"passed"=>"1", "id"=>"7"}, "1"=>{"passed"=>"0", "id"=>"9"}}

      resolutions[0].should_receive(:close!)

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
    let(:resolutions) {mock("resolutions", :find_by_id => resolution)}

    before(:each) do
      meeting.stub(:resolutions).and_return(resolutions)
    end

    it "updates the vote counts in the resolution records" do
      resolution.should_receive(:additional_votes_for=).with(3)
      resolution.should_receive(:additional_votes_against=).with(1)
      resolution.should_receive(:save!)

      meeting.passed_resolutions_attributes = passed_resolutions_attributes
      meeting.save!
    end

    it "it closes the proposals" do
      resolution.should_receive(:close!)

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
        meeting.organisation.stub(:secretary).and_return(secretary)

        tasks_association = mock("tasks association")
        secretary.stub(:tasks).and_return(tasks_association)

        tasks_association.should_receive(:create).with(hash_including(
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
        meeting.agenda_items.map(&:title).should eq [
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
      meeting.start_time.should == '16:45'
    rescue ActiveRecord::MultiparameterAssignmentErrors => mae
      raise mae.errors.map{|e| "#{e.attribute}: #{e.exception}"}.inspect + mae.backtrace.inspect
    end
  end

end
