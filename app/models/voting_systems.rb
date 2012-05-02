module VotingSystems  
  
  def self.get(klass)
    raise ArgumentError, "empty argument" if klass.nil?    
    begin
      const_get(klass.to_s) 
    rescue NameError
      nil
    end
  end
  
  # TODO Not all voting systems are applicable to all organisation types. The organisation
  # should have a way of specifying which voting systems it allows. (For example, an Association
  # should not have the option to choose AbsoluteThreeQuartersMajority.
  
  class VotingSystem
    
    def self.simple_name
      self.name.split('::').last
    end
    
    def self.description(options={})
      raise "description must be defined in subclasses of VotingSystem"
    end
    
    def self.long_description(options={})
      raise "long_description must be defined in subclasses of VotingSystem"
    end
    
    def self.can_be_closed_early?(proposal)
      false
    end
    
    def self.passed?(proposal)
      raise NotImplementedError      
    end
  end
  
  
  class RelativeMajority < VotingSystem
    def self.description(options={})
      "Simple majority: decisions need more supporting votes than opposing votes"
    end
    
    def self.long_description(options={})
      are_received = options[:include_received] ? " are received" : ""
      "Supporting Votes from more than half of the Members#{are_received} during the Voting Period; or when more Supporting Votes than Opposing Votes have been received for the Proposal at the end of the Voting Period."
    end
    
    def self.can_be_closed_early?(proposal)
      [proposal.votes_for, proposal.votes_against].max > (proposal.member_count  / 2.0)
    end
    
    def self.passed?(proposal)
      proposal.votes_for > proposal.votes_against      
    end
  end
  
  class Veto < VotingSystem
    def self.description(options={})
      "Nobody opposes: decisions blocked if there are any opposing votes"
    end
    
    def self.long_description(options={})
      are_received = options[:include_received] ? " are received" : ""
      "no Opposing Votes#{are_received} during the Voting Period."
    end
    
    def self.can_be_closed_early?(proposal)
      (proposal.votes_against > 0 ) ||
      (proposal.votes_for == proposal.member_count)
    end
    
    def self.passed?(proposal)
      proposal.votes_for > 0 && proposal.votes_against == 0
    end
  end
  

  # Base class for voting systems where a proposal needs to surpass a
  # treshold of votes (in relation to member count) to be accepted.
  class Majority < VotingSystem
    def self.fraction_needed=(f)
      @fraction_needed = f
    end
    
    def self.can_be_closed_early?(proposal)
      (current_fraction_for(proposal) > @fraction_needed) || 
      (current_fraction_against(proposal) >= (1.0 - @fraction_needed)) 
    end
    
    def self.passed?(proposal)
      current_fraction_for(proposal) > @fraction_needed
    end

    private

    def self.current_fraction_for(proposal)
      proposal.votes_for / proposal.member_count.to_f
    end
    
    def self.current_fraction_against(proposal)
      proposal.votes_against / proposal.member_count.to_f
    end
    
  end
  
  class AbsoluteMajority < Majority
    def self.description(options={})
      "Absolute majority: decisions need supporting votes from more than 50% of members"
    end
    
    def self.long_description(options={})
      are_received = options[:include_received] ? " are received" : ""
      "Supporting Votes#{are_received} from more than half of Members during the Voting Period."
    end
    
    self.fraction_needed = 0.5
  end
  
  class AbsoluteTwoThirdsMajority < Majority
    def self.description(options={})
      "Two thirds majority: decisions need supporting votes from more than 66% of members"
    end
    
    def self.long_description(options={})
      are_received = options[:include_received] ? " are received" : ""
      "Supporting Votes#{are_received} from more than two thirds of Members during the Voting Period."
    end
    
    self.fraction_needed = 2.0/3.0
  end
  
  class AbsoluteThreeQuartersMajority < Majority
    def self.description(options={})
      "Three quarters majority: decisions need supporting votes from more than 75% of members"
    end
    
    def self.long_description(options={})
      are_received = options[:include_received] ? " are received" : ""
      "Supporting Votes#{are_received} from more than three quarters of Members during the Voting Period."
    end
    
    self.fraction_needed = 3.0/4.0
  end
  
  class Unanimous < VotingSystem
    def self.description(options={})
      "Unanimous: decisions need supporting votes from 100% of members"
    end
    
    def self.long_description(options={})
      are_received = options[:include_received] ? " are received" : ""
      "Supporting Votes#{are_received} from all Members during the Voting Period."
    end
    
    def self.can_be_closed_early?(proposal)
      (proposal.votes_against > 0 ) ||
      (proposal.votes_for == proposal.member_count)
    end
    
    def self.passed?(proposal)
      proposal.votes_for == proposal.member_count
    end
  end
  
  class Founding < VotingSystem
    def self.description(options={})
      "At least three supporting votes"
    end
    
    def self.long_description(options={})
      are_received = options[:include_received] ? " are received" : ""
      "at least three votes#{are_received} during the Voting Period."
    end
    
    def self.can_be_closed_early?(proposal)
      # We need to give all the founding members an opportunity to vote,
      # so only close this proposal early if every member has cast a
      # vote.
      proposal.total_votes >= proposal.member_count
    end
    
    def self.passed?(proposal)
      proposal.votes_for >= 3
    end
  end
  
  def self.all(&block)
    [
      RelativeMajority,
      AbsoluteMajority,
      AbsoluteTwoThirdsMajority,
      Unanimous,
      Veto
    ].tap do |systems|
      systems.each(&block) if block
    end      
  end
end



