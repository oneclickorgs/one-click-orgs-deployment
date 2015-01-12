require 'spec_helper'

describe DirectorsController do
  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
  end

  context "when current organisation is a Company" do
    before(:each) do
      stub_company
      stub_login
    end

    describe "POST create" do
      before(:each) do
        @director_parameters = {:name => "Bob"}
        @director = mock_model(Director, :save => true, :send_welcome= => nil).as_new_record
        allow(@director).to receive(:send_new_director_notifications)
        allow(@company).to receive(:build_director).and_return(@director)

        allow(controller).to receive(:can?).with(:create, Director).and_return(true)
      end

      def post_create
        post :create, 'director' => @director_parameters
      end

      it "builds a new director" do
        expect(@company).to receive(:build_director).with('name' => "Bob").and_return(@director)
        post_create
      end

      it "saves the new director" do
        expect(@director).to receive(:save).and_return(true)
        post_create
      end

      it "sends notification emails to all directors" do
        expect(@director).to receive(:send_new_director_notifications)
        post_create
      end

      it "redirects to the members page" do
        post_create
        expect(response).to redirect_to('/members')
      end

      context "when director cannot be saved" do
        before(:each) do
          allow(@director).to receive(:save).and_return(false)
        end

        it "sets an error flash" do
          post_create
          expect(flash[:error]).to be_present
        end

        it "renders the 'new' template" do
          post_create
          expect(response).to render_template 'directors/new'
        end
      end

      describe "permissions checking" do
        context "when user is not allowed to create a director" do
          before(:each) do
            allow(controller).to receive(:can?).with(:create, Director).and_return false
          end

          it "should not create the director" do
            expect(@company).not_to receive(:build_director)
            expect(@director).not_to receive(:save)
            post_create
          end
        end
      end
    end

    describe "POST stand_down" do
      before(:each) do
        @directors_association = double("directors association")
        allow(@company).to receive(:directors).and_return(@directors_association)

        @director = mock_model(Director, :update_attributes => true, :eject! => true, :send_stand_down_notification_emails => nil)
        allow(@directors_association).to receive(:find).and_return(@director)

        @director_parameters = {"stood_down_on(1i)"=>"2011", "stood_down_on(2i)"=>"8", "stood_down_on(3i)"=>"6", "certification"=>"1"}
      end

      def post_stand_down
        post :stand_down, :id => '1', :director => @director_parameters
      end

      it "finds the director" do
        expect(@directors_association).to receive(:find).with('1').and_return(@director)
        post_stand_down
      end

      it "updates the directors attributes" do
        expect(@director).to receive(:update_attributes).with(@director_parameters)
        post_stand_down
      end

      it "ejects the director" do
        expect(@director).to receive(:eject!)
        post_stand_down
      end

      it "redirects to the members_page" do
        post_stand_down
        expect(response).to redirect_to('/members')
      end
    end
  end

  context "when current organisation is a Coop" do
    before(:each) do
      stub_coop
      stub_login
    end

    describe "GET index" do
      let(:tasks) {double("tasks")}

      before(:each) do
        allow(@organisation).to receive(:directors)
        allow(@organisation).to receive(:offices).and_return(@offices = double("offices association"))
        allow(@offices).to receive(:unoccupied).and_return([])

        @user.stub_chain(:tasks, :current, :directors_related).and_return(tasks)
      end

      def get_index
        get :index
      end

      it "assigns the offices" do
        get_index
        expect(assigns[:offices]).to eq(@offices)
      end

      it "assigns the currently-open, directors-related tasks for the current user" do
        get_index
        expect(assigns[:tasks]).to eq(tasks)
      end

      it "is successful" do
        get_index
        expect(response).to be_success
      end
    end
  end

end
