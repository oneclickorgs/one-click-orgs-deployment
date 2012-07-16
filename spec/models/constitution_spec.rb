require 'spec_helper'

describe Constitution do

  describe "for an Association" do
    before(:each) do
      @organisation = Association.make!(:name => 'abc', :objectives => 'def')
    end

    describe 'voting systems' do
      before do
        #avoid using the db in specs?
        @organisation.clauses.set_text!('general_voting_system', 'RelativeMajority')
      end

      describe "getting voting systems" do
        it "should get the voting system" do
          @organisation.constitution.voting_system(:general).should ==(VotingSystems::RelativeMajority)
        end

        it "should raise ArgumentError if invalid voting system is specified" do
          lambda { @organisation.constitution.voting_system(:invalid) }.should raise_error(ArgumentError)
        end
      end

      describe "changing the voting system" do
        it "should change the voting system" do
          @organisation.constitution.change_voting_system(:general, 'Unanimous')
          @organisation.constitution.voting_system(:general).should ==(VotingSystems::Unanimous)
        end

        it "should keep track of the previous voting system after changing it" do
          lambda {
            @organisation.constitution.change_voting_system(:general, 'Unanimous')
          }.should change { @organisation.clauses.where(:name => 'general_voting_system').count }.by(1)
          @organisation.clauses.where(:name => 'general_voting_system').order('id ASC')[-2].text_value.should == ('RelativeMajority')
        end

        it "should raise ArgumentError when invalid system is specified" do
          lambda { @organisation.constitution.change_voting_system(:general, nil) }.should raise_error(ArgumentError)
          lambda { @organisation.constitution.change_voting_system(:general, 'Invalid') }.should raise_error(ArgumentError)
        end
      end
    end

    describe "voting period" do
      before(:each) do
        @organisation.clauses.set_integer!('voting_period', 1000)
      end

      it "should get the current voting period" do
        @organisation.constitution.voting_period.should be_an(Integer)
        @organisation.constitution.voting_period.should >(0)
        @organisation.constitution.voting_period.should ==(1000)
      end

      it "should change the current voting period" do
        lambda { @organisation.constitution.change_voting_period(86400 * 2) }.should change(@organisation.constitution, :voting_period).from(1000).to(86400*2)
      end
    end
  end

  describe "for a Coop" do
    before(:each) do
      @organisation = Coop.make!
      @constitution = @organisation.constitution
    end

    describe "meeting notice period" do
      it "can be read" do
        @organisation.should_receive(:meeting_notice_period).and_return(14)
        @constitution.meeting_notice_period.should be_present
      end

      it "can be set" do
        @organisation.should_receive(:meeting_notice_period=).with(14)
        @constitution.meeting_notice_period = 14
      end
    end
  end
end
