require 'spec_helper'
require 'lib/vote_error'

describe Member do

  before(:each) do
    Delayed::Job.delete_all 
    
    default_association_constitution
    default_organisation

    @member = @organisation.members.make!
  end


  describe "defaults" do
    it "should be active" do
      @member.should be_active
    end
  end
  
  describe "validation" do
    it "requires a email address" do
      @member = Member.make(:email => "")
      @member.should_not be_valid
      @member.errors[:email].should be_present
    end
    
    it "requires a reasonable email address" do
      @member = Member.make(:email => "bob")
      @member.should_not be_valid
      @member.errors[:email].should be_present
      
      @member.email = "bob@example"
      @member.should_not be_valid
      @member.errors[:email].should be_present
      
      # (Invalid) double-quote character in local part
      @member.email = "bob\"@example.com"
      @member.should_not be_valid
      @member.errors[:email].should be_present
      
      @member.email = "bob@example.com"
      @member.should be_valid
    end
    
    it "requires a unique email address within the organisation" do
      @other_organisation = Organisation.make!
      @other_member = @other_organisation.members.make!(:email => "other@example.com")
      
      @fellow_member = @organisation.members.make!(:email => "fellow@example.com")
      
      @member = @organisation.members.make(:email => "other@example.com")
      @member.should be_valid
      
      @member.email = "fellow@example.com"
      @member.should_not be_valid
      @member.errors[:email].should be_present
    end
  end
  
  describe "voting" do
    before(:each) do
      @proposal = @organisation.proposals.make!(:proposer_member_id => @member.id)
    end
    
    it "should not allow votes on members inducted after proposal was made" do
      new_member = @organisation.members.make!(:created_at => Time.now + 1.day, :inducted_at => Time.now + 1.day)
      lambda {
        new_member.cast_vote(:for, @proposal)
      }.should raise_error(VoteError)
    end

    it "should not allow additional votes" do
      lambda {
        @member.cast_vote(:against, @proposal)
      }.should raise_error(VoteError)
    end
  end
  
  describe "creation" do
    it "should send a welcome email" do
      MembersMailer.should_receive(:welcome_new_member).and_return(mock('mail', :deliver => nil))
      @organisation.members.create({
        :email=>'foo@example.com',
        :first_name=>'Klaus',
        :last_name=>'Haus',
        :send_welcome => true
      })
    end
  end


  describe "ejection" do
    it "should toggle active flag after ejection" do
      lambda { @member.eject! }.should change(@member, :active?).from(true).to(false)
    end
  end

  describe "finders" do
    it "should return only active members" do
      @organisation.members.active.should == @organisation.members.all
      disabled = @organisation.members.make!(:state => 'inactive')
      @organisation.members.active.should == @organisation.members.all - [disabled]
    end
  end
  
  describe "name" do
    it "returns the full name for a member with first name and last name" do
      Member.new(:first_name => "Bob", :last_name => "Smith").name.should == "Bob Smith"
    end
    
    it "returns the first name for a member with a first name only" do
      Member.new(:first_name => "Bob").name.should == "Bob"
    end
    
    it "returns the last name for a member with a last name only" do
      Member.new(:last_name => "Smith").name.should == "Smith"
    end
    
    it "returns nil for a member with no first name and no last name" do
      Member.new.name.should be_nil
    end
  end
  
  describe "terms and conditions acceptance" do
    context "when creating a new member" do
      before(:each) do
        @member = Member.make
      end
      
      it "saves a timestamp when terms are accepted" do
        @member.terms_and_conditions = '1'
        @member.save.should be_true
        @member.terms_accepted_at.should_not be_nil
      end
      
      it "fails validation when terms are not accepted" do
        @member.terms_and_conditions = '0'
        @member.save.should be_false
      end
      
      it "does not save a timestamp when terms_and_conditions is not passed" do
        @member.terms_and_conditions = nil
        @member.save.should be_true
        @member.terms_accepted_at.should be_nil
      end
    end
    
    context "when updating an existing member" do
      before(:each) do
        @member = Member.make!(:terms_accepted_at => Time.now.utc - 1.day)
        @original_timestamp = @member.terms_accepted_at
      end
      
      it "does not alter the timestamp when terms_and_conditions is nil" do
        @member.terms_and_conditions = nil
        @member.save.should be_true
        @member.terms_accepted_at.should == @original_timestamp
      end
      
      it "does not alter an existing timestamp when terms are accepted again" do
        @member.terms_and_conditions = '1'
        @member.save.should be_true
        @member.terms_accepted_at.should == @original_timestamp
      end
      
      it "fails validation when terms are not accepted" do
        @member.terms_and_conditions = '0'
        @member.save.should be_false
      end
    end
  end
  
  describe "when a pending member is ejected before they are inducted" do
    before(:each) do
      @pending_member = Member.make!(:state => 'pending', :inducted_at => nil)
      @inducted_member = Member.make!
      @ejected_member = Member.make!(:inducted_at => nil)
      @ejected_member.eject!
    end
    
    describe "pending" do
      it "should list the pending members" do
        Member.pending.count.should == 1
        Member.pending.first.id.should == @pending_member.id
      end
    end
  end
  
  describe "resigning" do
    def mock_email
      mock("email", :deliver => nil)
    end
    
    it "creates a resignation record" do
      previous_resignation_count = @member.resignations.count
      @member.resign!
      @member.resignations.count.should == previous_resignation_count + 1
    end
    
    it "sends a notification email to the other members" do
      other_members = @organisation.members.make!(3)
      
      other_members.each do |other_member|
        MembersMailer.should_receive(:notify_resignation).with(other_member, @member).and_return(mock_email)
      end
      
      @member.resign!
    end
  end

  describe "associations" do
    it "has many ballots" do
      @member = Member.make!
      @ballot = Ballot.make!

      expect {@member.ballots << @ballot}.to_not raise_error

      @member.reload
      @member.ballots.reload

      @member.ballots.should include(@ballot)
    end

    it "has many tasks" do
      @member = Member.make!
      @task = Task.make!

      expect {@member.tasks << @task}.to_not raise_error

      @member.reload
      @member.tasks.reload

      @member.tasks.should include(@task)
    end
  end

  context "when organisation is a Coop" do
    before(:each) do
      @organisation = Coop.make!
    end

    context "on creation" do
      it "creates a task for the secretary" do
        @secretary = @organisation.members.make!(:secretary)
        expect {@member = @organisation.members.make!(:pending)}.to change{@secretary.tasks.count}.by(1)
        @secretary.tasks.last.subject.should == @member
      end
    end
  end
end
