class Resignation < ActiveRecord::Base
  belongs_to :member
  
  def to_event
    {:object => self, :timestamp => created_at, :kind => :resignation}
  end
end
