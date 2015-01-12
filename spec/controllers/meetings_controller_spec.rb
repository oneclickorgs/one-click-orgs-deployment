require 'spec_helper'

describe MeetingsController do
  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
  end

  context "when current organisation is a company" do
    before(:each) do
      stub_company
      stub_login
    end

    describe "GET show" do
      before(:each) do
        @meeting = mock_model(Meeting)

        @meetings_association = double("meetings association")
        allow(@meetings_association).to receive(:find).and_return(@meeting)

        allow(@company).to receive(:meetings).and_return(@meetings_association)

        @comments_association = double("comments association")
        allow(@meeting).to receive(:comments).and_return(@comments_association)

        @comment = mock_model(Comment).as_new_record
        allow(Comment).to receive(:new).and_return(@comment)

        allow(controller).to receive(:can?).with(:read, @meeting).and_return(true)
      end

      def get_show
        get :show, :id => '1'
      end

      it "finds the meeting" do
        expect(@meetings_association).to receive(:find).with('1').and_return(@meeting)
        get_show
      end

      it "assigns the meeting" do
        get_show
        expect(assigns(:meeting)).to eq(@meeting)
      end

      it "assigns the meeting's comments" do
        get_show
        expect(assigns(:comments)).to eq(@comments_association)
      end

      it "builds a new comment" do
        expect(Comment).to receive(:new).and_return(@comment)
        get_show
      end

      it "assigns the new comment" do
        get_show
        expect(assigns(:comment)).to eq(@comment)
      end

      it "renders the meetings/show template" do
        get_show
        expect(response).to render_template('meetings/show')
      end

      context "when user is not permitted to view the meeting" do
        before(:each) do
          allow(controller).to receive(:can?).with(:read, @meeting).and_return(false)
        end

        it "redirects to the dashboard" do
          get_show
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "POST create" do
      before(:each) do
        @meeting_parameters = {
          "happened_on(1i)" => "2011",
          "happened_on(2i)" => "5",
          "happened_on(3i)" => "1",
          "participant_ids" => {"1001" => "1", "1002" => "1"},
          "minutes" => "Preferred coffee suppliers."
        }

        @meetings_association = double("meetings association")
        allow(@company).to receive(:meetings).and_return(@meetings_association)

        @meeting = mock_model(Meeting, :creator= => nil).as_new_record
        allow(@meetings_association).to receive(:build).and_return(@meeting)

        allow(@meeting).to receive(:attributes=)
        allow(@meeting).to receive(:save).and_return(true)

        allow(controller).to receive(:can?).with(:create, Meeting).and_return(true)
      end

      def post_create
        post :create, 'meeting' => @meeting_parameters
      end

      it "builds the new meeting without setting attributes" do
        # This is to avoid trying to set the participants before
        # setting the organisation, since Meeting has to validate
        # the participants' membership of the organisation.
        expect(@meetings_association).to receive(:build).with().and_return(@meeting)
        post_create
      end

      it "sets the meeting's attributes" do
        expect(@meeting).to receive(:attributes=).with(@meeting_parameters)
        post_create
      end

      it "saves the meeting" do
        expect(@meeting).to receive(:save).and_return(true)
        post_create
      end

      it "logs that the current user created the meeting" do
        expect(@meeting).to receive(:creator=).with(@user)
        post_create
      end

      it "redirects to the dashboard" do
        post_create
        expect(response).to redirect_to '/'
      end

      context "when saving the meeting fails" do
        before(:each) do
          allow(@meeting).to receive(:save).and_return(false)

          @member_classes_association = double("member classes association")
          allow(@company).to receive(:member_classes).and_return(@member_classes_association)

          @director_member_class = mock_model(Director)
          allow(@member_classes_association).to receive(:find_by_name).and_return(@director_member_class)

          @members_association = double("members association")
          allow(@company).to receive(:members).and_return(@members_association)

          @directors = double("directors")
          allow(@members_association).to receive(:where).and_return(@directors)
        end

        it "finds the directors" do
          expect(@member_classes_association).to receive(:find_by_name).with('Director').and_return(@director_member_class)
          expect(@members_association).to receive(:where).with(:member_class_id => @director_member_class.id).and_return(@directors)
          post_create
        end

        it "assigns the directors" do
          post_create
          expect(assigns(:directors)).to eq(@directors)
        end

        it "renders the 'new' template" do
          post_create
          expect(response).to render_template 'meetings/new'
        end

        it "sets an error flash" do
          post_create
          expect(flash[:error]).to be_present
        end
      end

      context "when the user is not permitted to create a meeting" do
        before(:each) do
          allow(controller).to receive(:can?).with(:create, Meeting).and_return(false)
        end

        it "does not save the meeting" do
          expect(@meeting).not_to receive(:save)
          post_create
        end
      end
    end
  end

  context "when current organisation is a co-op" do
    before(:each) do
      stub_coop
      stub_login
    end

    describe "GET index" do
      before(:each) do
        @general_meetings_association = double("general meetings association")
        @upcoming_meetings = double("upcoming general meetings association")
        @past_meetings = double("past general meetings association")

        allow(@organisation).to receive(:general_meetings).and_return(@general_meetings_association)
        allow(@general_meetings_association).to receive(:upcoming).and_return(@upcoming_meetings)
        allow(@general_meetings_association).to receive(:past).and_return(@past_meetings)
      end

      it "finds and assigns the upcoming general meetings" do
        expect(@general_meetings_association).to receive(:upcoming).and_return(@upcoming_meetings)
        get :index
        expect(assigns[:upcoming_meetings]).to eq(@upcoming_meetings)
      end

      it "finds and assigns the past general meetings" do
        expect(@general_meetings_association).to receive(:past).and_return(@past_meetings)
        get :index
        expect(assigns[:past_meetings]).to eq(@past_meetings)
      end

      it "is successful" do
        get :index
        expect(response).to be_success
      end
    end
  end

end
