require 'spec_helper'

describe 'shared/association/_main_menu' do

  let(:user) {mock_model(Member)}
  let(:organisation) {mock_model(Association)}

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
    allow(view).to receive(:current_organisation).and_return(organisation)
  end

  context 'when the association is pending' do
    before(:each) do
      allow(organisation).to receive(:pending?).and_return(true)
    end

    it 'renders a link to the warnings for founder members' do
      render
      expect(rendered).to have_selector(:a, href: '/associations/warnings')
    end
  end

end
