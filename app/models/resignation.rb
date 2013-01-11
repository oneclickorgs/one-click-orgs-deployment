class Resignation < ActiveRecord::Base
  attr_accessible # none
  
  belongs_to :member
  
  def to_event
    {:object => self, :timestamp => created_at, :kind => :resignation}
  end
end
