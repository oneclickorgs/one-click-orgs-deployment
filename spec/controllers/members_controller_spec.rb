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
        @company.stub(:directors).and_return(@directors_association)

        @directors = double("directors")
        @directors_association.stub(:active).and_return(@directors)

        @director = mock_model(Director)
        Director.stub(:new).and_return(@director)
      end

      def get_index
        get :index
      end

      it "finds the active directors" do
        @directors_association.should_receive(:active).and_return(@directors)
        get_index
      end

      it "assigns the directors" do
        get_index
        assigns(:members).should == @directors
      end

      it "builds a new director" do
        Director.should_receive(:new).and_return(@director)
        get_index
      end

      it "assigns the new director" do
        get_index
        assigns(:director).should == @director
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
        @organisation.stub(:members).and_return(members)
        controller.stub(:can?).and_return(false)
        @user.stub_chain(:tasks, :members_related, :current)
      end

      def get_index
        get :index
      end

      it "finds the active members" do
        members.should_receive(:active).and_return(active_members)
        get_index
      end

      it "assigns the active members" do
        get_index
        assigns[:members].should == active_members
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
        @organisation.stub(:members).and_return(members)
        @organisation.stub(:share_account).and_return(organisation_share_account)
        ShareTransaction.stub(:create).and_return(share_transaction)
      end

      def put_induct
        put :induct, 'id' => '1'
      end

      it "finds the member" do
        members.should_receive(:find).with('1').and_return(member)
        put_induct
      end

      it "inducts the member" do
        member.should_receive(:induct!)
        put_induct
      end

      it "redirects" do
        put_induct
        response.should be_redirect
      end

      describe "authorisation" do
        it "is checked"
      end
    end

    describe "GET confirm_eject" do
      let(:member) {mock_model(Member)}
      let(:members) {double("members association", :find => member)}

      before(:each) do
        @organisation.stub(:members).and_return(members)
      end

      def get_confirm_eject
        get :confirm_eject, 'id' => '3000'
      end

      it "finds the member" do
        members.should_receive(:find).with('3000').and_return(member)
        get_confirm_eject
      end

      it "assigns the member" do
        get_confirm_eject
        assigns[:member].should == member
      end

      it "is successful" do
        get_confirm_eject
        response.should be_successful
      end

      describe "authorisation" do
        it "is checked"
      end
    end

    describe "PUT eject" do
      let(:member) {mock_model(Member, :eject! => nil, :name => "Bob Smith")}
      let(:members) {double("members association", :find => member)}

      before(:each) do
        @organisation.stub(:members).and_return(members)
      end

      def put_eject
        put :eject, 'id' => '3000'
      end

      it "finds the member" do
        members.should_receive(:find).with('3000').and_return(member)
        put_eject
      end

      it "ejects the member" do
        member.should_receive(:eject!)
        put_eject
      end

      it "sets a notice flash" do
        put_eject
        flash[:notice].should be_present
      end

      it "redirects" do
        put_eject
        response.should be_redirect
      end

      describe "authorisation" do
        it "is checked"
      end
    end
  end

end
