require 'spec_helper'

describe ShareApplication do

  it "implements #persisted?" do
    ShareApplication.new.persisted?.should be_false
  end

  it "builds a share transaction if not given one" do
    share_application = ShareApplication.new
    share_application.share_transaction.should be_a(ShareTransaction)
  end

  it "accepts attribtues on initialization" do
    share_application = ShareApplication.new(:amount => 5)
    share_application.amount.should == 5
  end

  it "delegates 'amount' to the share transaction" do
    ShareApplication.new.amount.should be_nil
  end

  describe "saving" do
    it "saves the share transaction" do
      share_application = ShareApplication.new

      share_application.share_transaction.should_receive(:save).and_return(true)

      share_application.save
    end
  end

end
