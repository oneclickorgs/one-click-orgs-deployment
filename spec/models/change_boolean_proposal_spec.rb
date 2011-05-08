require 'spec_helper'

describe ChangeBooleanProposal do
  it "has a decision notification message" do
    ChangeBooleanProposal.new.decision_notification_message.should be_present
  end
end
