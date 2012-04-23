class Decision < ActiveRecord::Base
  attr_accessible # none
  
  belongs_to :proposal
  
  def organisation
    proposal.organisation if proposal
  end
  
  def to_event
    { :timestamp => self.proposal.close_date, :object => self, :kind => :decision }    
  end 
end
