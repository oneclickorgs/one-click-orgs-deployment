require 'spec_helper'

describe Invitation do
  
  before(:each) do
    @member = mock_model(Member,
      :invitation_code => nil,
      :terms_and_conditions= => nil
    )
  end
  
  subject { Invitation.new(:member => @member) }
  
  it_behaves_like "an active model"
  
  it "sets terms_and_conditions to '0'" do
    @member.should_receive(:terms_and_conditions=).with('0')
    Invitation.new(:member => @member)
  end
end
