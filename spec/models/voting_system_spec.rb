require 'spec_helper'

describe VotingSystems do

  def make_proposal(v_for, v_against, total_m=v_for+v_against)
    p = mock_model(Proposal)
    p.stub(:votes_for).and_return(v_for)
    p.stub(:votes_against).and_return(v_against)
    p.stub(:member_count).and_return(total_m)
    p.stub(:total_votes).and_return(v_for + v_against)
    p
  end

  def _should_have_description
    @system.description.should_not be_blank
  end
  
  def should_pass(proposal)
     @system.passed?(proposal).should be_true
  end

  def should_not_pass(proposal)
     @system.passed?(proposal).should be_false
  end
  
  def should_close_early(proposal)
     @system.can_be_closed_early?(proposal).should be_true
  end

  def should_not_close_early(proposal)
     @system.can_be_closed_early?(proposal).should be_false
  end

  describe VotingSystems do
    it "should return all voting systems" do
      VotingSystems.all.map {|s|s.name.split('::')[-1] }.should == ["RelativeMajority", "AbsoluteMajority", "AbsoluteTwoThirdsMajority", "Unanimous", "Veto"]
    end
  end
  
  describe VotingSystems::RelativeMajority do    
    before do
      @system = VotingSystems::RelativeMajority
    end

    it "relative majority" do
      should_not_pass make_proposal(0, 0, 1)
      should_pass make_proposal(5, 4)
      should_not_pass make_proposal(4, 5)

      should_not_close_early make_proposal(0, 0, 1)
      should_close_early make_proposal(5, 4)
      should_not_close_early make_proposal(5, 4, 11)
      should_close_early make_proposal(4, 5)
      should_not_close_early make_proposal(4, 5, 11)
    end
  end
  
  describe VotingSystems::RelativeThreeQuartersMajority do
    before(:each) do
      @system = VotingSystems::RelativeThreeQuartersMajority
    end
    
    it "passes when votes in favour are more than three-quarters of total votes" do
      should_pass make_proposal(76, 24)
    end
    
    it "does not pass when votes in favour are equal to three-quarters of total votes" do
      should_not_pass make_proposal(75, 25)
    end
    
    it "does not pass when votes in favour are less than three-quarters of total votes" do
      should_not_pass make_proposal(74, 26)
    end
    
    it "still passes when votes in favour are less than three-quarters of members" do
      should_pass make_proposal(76, 24, 1000)
    end
    
    it "closes early when more than three-quarters of the members have voted in favour" do
      should_close_early make_proposal(76, 0, 100)
    end
    
    it "closes early when one quarter of the members have voted against" do
      should_close_early make_proposal(0, 25, 100)
    end
  end

  describe VotingSystems::Veto do    
    before(:each) do
      @system = VotingSystems::Veto
    end

    it "should have a description" do
      _should_have_description
    end
    
    it "veto" do
      should_not_pass make_proposal(0, 0, 1)
      should_not_pass make_proposal(5, 4)
      should_not_pass make_proposal(4, 5)

      should_not_close_early make_proposal(0, 0, 1)
      should_close_early make_proposal(1, 0, 1)     
      should_close_early make_proposal(2, 0, 2)     # everyone has voted    
      should_close_early make_proposal(5, 4)
      should_close_early make_proposal(4, 5)
      should_not_close_early make_proposal(5, 0, 9)
    end
  end

  describe VotingSystems::AbsoluteMajority do    
    before do
      @system = VotingSystems::AbsoluteMajority
    end

    it "absolute" do
      should_pass make_proposal(10, 9)
      should_not_pass make_proposal(9, 10)

      should_close_early make_proposal(10, 9)
      should_close_early make_proposal(9, 10)
      
      # Edge cases
      
      # Absolute majority requires more than 50% of the membership
      # to vote in favour. It is not enough if exactly 50% of the
      # membership votes in favour.
      should_pass make_proposal(6, 0, 10)
      should_not_pass make_proposal(5, 0, 10)
      should_close_early make_proposal(6, 0, 10)
      should_not_close_early make_proposal(5, 0, 10)
    end
  end


  describe VotingSystems::AbsoluteTwoThirdsMajority do    
    before do
      @system = VotingSystems::AbsoluteTwoThirdsMajority
    end

    it "absolute two thirds majority" do
      should_pass make_proposal(67, 33)
      should_not_pass make_proposal(4, 5)
      should_not_pass make_proposal(51, 49)            

      should_close_early make_proposal(67, 33)
      should_close_early make_proposal(4, 5)
      should_not_close_early make_proposal(3, 4, 20)            
    end
  end
  
  describe VotingSystems::AbsoluteThreeQuartersMajority do
    before(:each) do
      @system = VotingSystems::AbsoluteThreeQuartersMajority
    end
    
    it "passes when the votes in favour are greater than 3/4 of the membership" do
      should_pass make_proposal(76, 0, 100)
    end
    
    it "does not pass when the votes in favour are equal to 3/4 of the membership" do
      should_not_pass make_proposal(75, 0, 100)
    end
    
    it "does not pass when votes in favour are less than 3/4 of the membership, even though they are more than 3/4 of the total votes" do
      should_not_pass make_proposal(7, 1, 100)
    end
  end


  describe VotingSystems::Unanimous do    
    before do
      @system = VotingSystems::Unanimous
    end
    
    it "unanimous" do
      should_not_pass make_proposal(0, 0, 1)
      should_pass make_proposal(5, 0)
      should_not_pass make_proposal(10, 1)

      should_not_close_early make_proposal(0, 0, 1)
      should_close_early make_proposal(5, 0)
      should_close_early make_proposal(10, 1)
    end
  end
  
  describe VotingSystems::Founding do
    before do
      @system = VotingSystems::Founding
    end
    
    it "requires three or more supporting votes" do
      should_not_pass make_proposal(2, 1, 3)
      should_pass make_proposal(3, 1, 20)
    end
    
    it "closes early only when all members have voted" do
      should_close_early make_proposal(3, 0, 3)
      should_not_close_early make_proposal(3, 0, 4)
      should_not_close_early make_proposal(1, 1, 3)
    end
  end
end
