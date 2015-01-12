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

      expect(task.subject(true)).to eq(resolution)
    end
  end

  describe "scopes" do
    describe "current" do
      before(:each) do
        @completed_task = Task.make!(:completed_at => 10.seconds.ago)
        @future_task = Task.make!(:starts_on => Date.today.advance(:days => 1))
        @task = Task.make!
      end

      it "does not include completed tasks" do
        expect(Task.current).not_to include(@completed_task)
      end

      it "does not include future tasks" do
        expect(Task.current).not_to include(@future_task)
      end

      it "includes other tasks" do
        expect(Task.current).to include(@task)
      end
    end

    describe "shares-related" do
      before(:each) do
        @share_transaction_task = Task.make!(:subject => ShareTransaction.make!)
        @member_task = Task.make!(:subject => Member.make!)
      end

      it "includes tasks with a ShareTransaction as the subject" do
        expect(Task.shares_related).to include(@share_transaction_task)
      end

      it "does not include tasks with a Member as the subject" do
        expect(Task.shares_related).not_to include(@member_task)
      end
    end

    describe "directors-related" do
      before(:each) do
        @election_task = Task.make!(:subject => Election.make!)
        @member_task = Task.make!(:subject => Member.make!)
      end

      it "includes tasks with an Election as the subject" do
        expect(Task.directors_related).to include(@election_task)
      end

      it "does not include tasks with a Member as the subject" do
        expect(Task.directors_related).not_to include(@member_task)
      end
    end
  end

end
