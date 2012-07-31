class Election < ActiveRecord::Base
  attr_accessible :organisation

  state_machine :initial => :draft do
    event :close do
      transition :open => :closed
    end
    
    event :start do
      transition :draft => :open
    end
  end

  belongs_to :organisation
  has_many :nominations
  has_many :nominees, :through => :nominations
  has_many :ballots
end
