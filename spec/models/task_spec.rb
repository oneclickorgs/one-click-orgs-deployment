require 'spec_helper'

describe Task do

  describe "mass assignment" do
    it "allows mass-assignment of 'subject'" do
      resolution = Resolution.make
      expect {Task.new(:subject => resolution)}.to_not raise_error
    end
  end

  describe "associations" do
    it "belongs to a polymorphic subject" do
      resolution = Resolution.make!
      task = Task.make!

      expect {task.subject = resolution}.to_not raise_error

      task.save!
      task.reload
      
      task.subject(true).should == resolution
    end
  end

end
