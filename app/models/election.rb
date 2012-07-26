class Election < ActiveRecord::Base
  state_machine :initial => :draft do
    event :close do
      transition :open => :closed
    end
    
    event :start do
      transition :draft => :open
    end
  end

  has_many :nominations
  has_many :nominees, :through => :nominations
  has_many :ballots
end
