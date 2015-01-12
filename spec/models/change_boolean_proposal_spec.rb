require 'spec_helper'

describe ChangeBooleanProposal do
  it "has a decision notification message" do
    expect(ChangeBooleanProposal.new.decision_notification_message).to be_present
  end
end
