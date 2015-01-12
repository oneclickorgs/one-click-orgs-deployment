require 'spec_helper'

module OneClickControllerSpecHelper
  def mock_event
    double("event").tap do |event|
      allow(event).to receive(:[]).with(:timestamp) do
        rand(5).days.ago
      end
    end
  end

  def get_dashboard
    get :dashboard
  end
end

describe OneClickController do
  include OneClickControllerSpecHelper
  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
  end

  context "when current organisation is a company" do
    before(:each) do
      stub_company
      stub_login
    end

    describe "GET dashboard" do
      before(:each) do
        @meeting = mock_model(Meeting)
        allow(Meeting).to receive(:new).and_return(@meeting)

        @members_association = double("members association")
        allow(@company).to receive(:members).and_return(@members_association)
        @member_classes_association = double("member classes association")
        allow(@company).to receive(:member_classes).and_return(@member_classes_association)
        @director_member_class = mock_model(MemberClass)
        allow(@member_classes_association).to receive(:find_by_name).and_return(@director_member_class)
        @directors = double("directors")
        allow(@members_association).to receive(:where).and_return(@directors)

        @proposals = [
          mock_model(Proposal, :to_event => mock_event),
          mock_model(Proposal, :to_event => mock_event)
        ]
        @meetings = [
          mock_model(Meeting, :to_event => mock_event),
          mock_model(Meeting, :to_event => mock_event)
        ]
        @company.stub_chain(:meetings, :all).and_return(@meetings)

        allow(@company).to receive(:proposals).and_return(@proposals)
        @company.stub_chain(:decisions, :all).and_return([])

        allow(@proposals).to receive(:all).and_return(@proposals)
        allow(@proposals).to receive(:currently_open).and_return(@proposals)

        allow(@proposals).to receive(:new).and_return(mock_model(Proposal))
      end

      it "builds a new meeting" do
        expect(Meeting).to receive(:new).and_return(@meeting)
        get_dashboard
      end

      it "assigns the new meeting" do
        get_dashboard
        expect(assigns(:meeting)).to eq(@meeting)
      end

      it "finds the directors" do
        expect(@member_classes_association).to receive(:find_by_name).with('Director').and_return(@director_member_class)
        expect(@members_association).to receive(:where).with(:member_class_id => @director_member_class.id).and_return(@directors)
        get_dashboard
      end

      it "assigns the directors" do
        get_dashboard
        expect(assigns(:directors)).to eq(@directors)
      end

      describe "timeline" do
        it "assigns the timeline" do
          get_dashboard
          timeline = assigns(:timeline)
          expect(timeline).to respond_to(:each)
          timeline.each do |event|
            expect(event[:timestamp]).to be_present
          end
        end
      end
    end
  end

  context "when current organisation is an association" do
    before(:each) do
      stub_association
      stub_login
    end

    describe "GET dashboard" do
      before(:each) do
        @association.stub_chain(:add_member_proposals, :build).and_return(mock_model(AddMemberProposal))
        @association.stub_chain(:proposals, :currently_open).and_return([])
        @association.stub_chain(:proposals, :new).and_return(mock_model(Proposal))
        @association.stub_chain(:members, :new).and_return(mock_model(Member))
        allow(@association).to receive(:default_member_class).and_return(mock_model(MemberClass))

        @association.stub_chain(:members, :all).and_return([])
        @association.stub_chain(:proposals, :all).and_return([])
        @association.stub_chain(:decisions, :all).and_return([])
      end

      describe "timeline" do
        it "includes Resignation events" do
          @resignation_event = double('resignation event')
          @association.stub_chain(:resignations, :all).and_return(mock_model(Resignation,
            :to_event => @resignation_event
          ))

          get_dashboard
          expect(assigns[:timeline]).to include(@resignation_event)
        end
      end
    end
  end

  context "when current organisation is a co-op" do
    let(:decisions) {[decision]}
    let(:decision) {mock_model(Decision, :to_event => decision_event)}
    let(:decision_event) {double("decision event")}

    before(:each) do
      stub_coop
      stub_login

      @proposals_association = double("proposals association")
      allow(@organisation).to receive(:proposals).and_return(@proposals_association)

      @proposals_association.stub_chain(:currently_open, :reject)
      allow(@proposals_association).to receive(:new)

      @organisation.stub_chain(:members, :all).and_return([])

      @organisation.stub_chain(:general_meetings, :all).and_return([])
      @organisation.stub_chain(:general_meetings, :upcoming, :order, :first)
      @organisation.stub_chain(:general_meetings, :upcoming, :count).and_return(0)
      @organisation.stub_chain(:general_meetings, :past, :order, :first)

      allow(@organisation).to receive(:resolutions).and_return(double("resolutions", :currently_open => []))
      allow(@organisation).to receive(:resolution_proposals).and_return([])
      allow(@organisation).to receive(:decisions).and_return([])

      @tasks_association = double("tasks association")
      allow(@user).to receive(:tasks).and_return(@tasks_association)

      @current_tasks_association = double("current tasks association")
      allow(@tasks_association).to receive(:current).and_return(@current_tasks_association)

      allow(@current_tasks_association).to receive(:undismissed).and_return(@undismissed_tasks)

      allow(@current_tasks_association).to receive(:members_or_shares_related)

      allow(@organisation).to receive(:active?).and_return(true)

      allow(@user).to receive(:has_permission)
      allow(@user).to receive(:organisation).and_return(@organisation)
      allow(@organisation).to receive(:pending?).and_return(false)
    end

    it "finds the current user's current undismissed tasks" do
      expect(@current_tasks_association).to receive(:undismissed).and_return(@undismissed_tasks)
      get_dashboard
    end

    it "assigns the current user's current tasks" do
      get_dashboard
      expect(assigns[:tasks]).to eq(@undismissed_tasks)
    end
  end

end
