require 'spec_helper'

describe ResolutionsController do

  include ControllerSpecHelper

  before(:each) do
    stub_app_setup
    stub_coop
    stub_login
  end

  describe "POST create" do
    before(:each) do
      @resolution_params = {'description' => "Do things"}

      @resolutions_association = double("resolutions association")
      @organisation.stub(:resolutions).and_return(@resolutions_association)

      @resolution = mock_model(Resolution, :proposer= => nil, :save => true, :creation_success_message => nil)
      @resolutions_association.stub(:build).and_return(@resolution)
    end

    def post_create
      post :create, 'resolution' => @resolution_params
    end

    describe "creating a generic resolution" do
      it "builds the new resolution" do
        @resolutions_association.should_receive(:build).with(@resolution_params).and_return(@resolution)
        post_create
      end

      it "set the proposer to the current user" do
        @resolution.should_receive(:proposer=).with(@user)
        post_create
      end

      it "saves the new resolution" do
        @resolution.should_receive(:save).and_return(true)
        post_create
      end

      it "redirects to the proposals page" do
        post_create
        response.should redirect_to('/proposals')
      end
    end

    describe "creating a Rule-change resolution" do
      let(:change_name_resolution) {mock_model(ChangeNameResolution,
        :attributes= => nil,
        :proposer= => nil,
        :save => true,
        :creation_success_message => nil
      )}

      before(:each) do
        ChangeNameResolution.stub(:new).and_return(change_name_resolution)
      end

      def post_create
        post :create, 'change_name_resolution' => {'organisation_name' => 'New Name'}
      end

      it "redirects to the proposals page" do
        post_create
        response.should redirect_to('/proposals')
      end
    end

    context "when saving the new resolution fails" do
      it "handles the error"
    end

    it "checks authorisation"
  end

end
