require 'spec_helper'

describe 'members/coop/index' do

  let(:organisation) {mock_model(Organisation, :active? => true)}

  before(:each) do
    assign(:members, [])
    allow(view).to receive(:co).and_return(organisation)
  end

  context "when user can update the organisation" do
    before(:each) do
      allow(view).to receive(:can?).with(:update, organisation).and_return(true)
    end

    it "renders a button to edit the membership application form" do
      render
      expect(rendered).to have_selector(:form, :action => '/membership_application_form/edit')
    end
  end

end
