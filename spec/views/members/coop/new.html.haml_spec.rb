require 'spec_helper'

describe 'members/coop/new' do

  let(:organisation) {mock_model(Organisation,
    :name => "The Co-op"
  )}
  let(:member) {mock_model(Member,
    :certify_share_application => nil,
    :certify_age => nil
  ).as_new_record}

  before(:each) do
    view.stub(:co).and_return(organisation)
    assign(:member, member)
  end

  context "when there exists custom text for the membership application form" do
    before(:each) do
      organisation.stub(:membership_application_text).and_return("Custom text.")
    end

    it "renders the custom text" do
      render
      rendered.should have_content("Custom text.")
    end
  end

end
