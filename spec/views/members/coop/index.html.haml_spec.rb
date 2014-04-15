require 'spec_helper'

describe 'members/coop/index' do

  let(:organisation) {mock_model(Organisation, :active? => true)}

  before(:each) do
    assign(:members, [])
    view.stub(:co).and_return(organisation)
  end

  context "when user can update the organisation" do
    before(:each) do
      view.stub(:can?).with(:update, organisation).and_return(true)
    end

    it "renders a button to edit the membership application form" do
      render
      rendered.should have_selector(:form, :action => '/membership_application_form/edit')
    end
  end

end
