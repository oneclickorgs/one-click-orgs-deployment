require 'spec_helper'

describe 'members/coop/show' do

  let(:member) {mock_model(Member,
    :gravatar_url => nil,
    :name => "Bob Smith",
    :to_param => '11',
    :shares_count => 0,
    :active? => true,
    :pending? => false
  )}

  before(:each) do
    assign(:member, member)
  end

  context "when user can edit members" do
    before(:each) do
      view.stub(:can?).with(:edit, member).and_return(true)
      view.stub(:current_user).and_return(mock_model(Member))
    end

    it "renders a button terminate the membership" do
      render
      rendered.should have_selector(:a, :href => '/members/11/confirm_eject')
    end

    context "when member is pending" do
      before(:each) do
        member.stub(:active?).and_return(false)
        member.stub(:pending?).and_return(true)
      end

      it "renders a button to accept the membership application" do
        render
        rendered.should have_selector(:form, :action => "/members/11/induct") do |form|
          form.should have_selector(:input, :name => '_method', :value => 'put')
          form.should have_selector(:input, :type => 'submit')
        end
      end
    end
  end

end
