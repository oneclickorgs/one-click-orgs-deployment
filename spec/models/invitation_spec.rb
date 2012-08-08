require 'spec_helper'

describe Invitation do

  before(:each) do
    @organisation = mock_model(Organisation,
      :terms_and_conditions_required? => false
    )

    @member = mock_model(Member,
      :invitation_code => nil,
      :terms_and_conditions= => nil,
      :organisation => @organisation
    )
  end

  subject { Invitation.new(:member => @member) }

  it_behaves_like "an active model"

  context "when organisation requires terms_and_conditions" do
    before(:each) do
      @organisation.stub(:terms_and_conditions_required?).and_return(true)
    end

    it "sets terms_and_conditions to '0'" do
      @member.should_receive(:terms_and_conditions=).with('0')
      Invitation.new(:member => @member)
    end
  end

end
