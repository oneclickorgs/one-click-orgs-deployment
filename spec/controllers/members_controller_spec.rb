require 'spec_helper'

describe MembersController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
  end

  context "when current organisation is a company" do
    before(:each) do
      stub_company
      stub_login
    end

    describe "GET index" do
      before(:each) do
        @directors_association = double("directors association")
        allow(@company).to receive(:directors).and_return(@directors_association)

        @directors = double("directors")
        allow(@directors_association).to receive(:active_and_pending).and_return(@directors)

        @director = mock_model(Director)
        allow(Director).to receive(:new).and_return(@director)
      end

      def get_index
        get :index
      end

      it "finds the active and pending directors" do
        expect(@directors_association).to receive(:active_and_pending).and_return(@directors)
        get_index
      end

      it "assigns the directors" do
        get_index
        expect(assigns(:members)).to eq(@directors)
      end

      it "builds a new director" do
        expect(Director).to receive(:new).and_return(@director)
        get_index
      end

      it "assigns the new director" do
        get_index
        expect(assigns(:director)).to eq(@director)
      end
    end
  end

  context "when current organisation is a co-op" do
    before(:each) do
      stub_coop
      stub_login
    end

    describe "GET index" do
      let(:members){double("members association", :active => active_members)}
      let(:active_members){double("active members association")}

      before(:each) do
        allow(@organisation).to receive(:members).and_return(members)
        allow(controller).to receive(:can?).and_return(false)
        @user.stub_chain(:tasks, :members_related, :current)
      end

      def get_index
        get :index
      end

      it "finds the active members" do
        expect(members).to receive(:active).and_return(active_members)
        get_index
      end

      it "assigns the active members" do
        get_index
        expect(assigns[:members]).to eq(active_members)
      end
    end

    describe "POST create" do
      context "when saving the new member fails" do
        let(:member) {mock_model(Member, :member_class= => nil)}
        let(:members_association) {double('members association', build: member)}
        let(:member_classes_association) {double('member classes association', find_by_name: member_class)}
        let(:member_class) {mock_model(MemberClass)}

        before(:each) do
          allow(member).to receive(:save).and_return(false)
          allow(@organisation).to receive(:members).and_return(members_association)
          allow(@organisation).to receive(:member_classes).and_return(member_classes_association)
        end

        def post_create
          post :create
        end

        it "sets an error flash" do
          post_create
          expect(flash[:error]).to be_present
        end

        it "renders the 'new' action" do
          post_create
          expect(response).to render_template('members/new')
        end

      end
    end

    describe "PUT induct" do
      let(:members){double("members association", :find => member)}
      let(:member){mock_model(Member,
        :send_welcome= => true,
        :can_induct? => true,
        :active? => true,
        :induct! => nil,
        :find_or_create_share_account => member_share_account
      )}
      let(:member_share_account){mock_model(ShareAccount).as_new_record}
      let(:organisation_share_account){mock_model(ShareAccount)}
      let(:share_transaction){mock_model(ShareTransaction, :save! => true, :approve! => nil).as_new_record}

      before(:each) do
        allow(@organisation).to receive(:members).and_return(members)
        allow(@organisation).to receive(:share_account).and_return(organisation_share_account)
        allow(ShareTransaction).to receive(:create).and_return(share_transaction)
      end

      def put_induct
        put :induct, 'id' => '1'
      end

      it "finds the member" do
        expect(members).to receive(:find).with('1').and_return(member)
        put_induct
      end

      it "inducts the member" do
        expect(member).to receive(:induct!)
        put_induct
      end

      it "redirects" do
        put_induct
        expect(response).to be_redirect
      end

      describe "authorisation" do
        it "is checked"
      end
    end

    describe "GET confirm_eject" do
      let(:member) {mock_model(Member)}
      let(:members) {double("members association", :find => member)}

      before(:each) do
        allow(@organisation).to receive(:members).and_return(members)
      end

      def get_confirm_eject
        get :confirm_eject, 'id' => '3000'
      end

      it "finds the member" do
        expect(members).to receive(:find).with('3000').and_return(member)
        get_confirm_eject
      end

      it "assigns the member" do
        get_confirm_eject
        expect(assigns[:member]).to eq(member)
      end

      it "is successful" do
        get_confirm_eject
        expect(response).to be_successful
      end

      describe "authorisation" do
        it "is checked"
      end
    end

    describe "PUT eject" do
      let(:member) {mock_model(Member, :eject! => nil, :name => "Bob Smith")}
      let(:members) {double("members association", :find => member)}

      before(:each) do
        allow(@organisation).to receive(:members).and_return(members)
      end

      def put_eject
        put :eject, 'id' => '3000'
      end

      it "finds the member" do
        expect(members).to receive(:find).with('3000').and_return(member)
        put_eject
      end

      it "ejects the member" do
        expect(member).to receive(:eject!)
        put_eject
      end

      it "sets a notice flash" do
        put_eject
        expect(flash[:notice]).to be_present
      end

      it "redirects" do
        put_eject
        expect(response).to be_redirect
      end

      describe "authorisation" do
        it "is checked"
      end
    end
  end

end
