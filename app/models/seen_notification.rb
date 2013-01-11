# A SeenNotification is created when a particular member has seen a particular
# notification, so that we can avoid showing it to them again.
class SeenNotification < ActiveRecord::Base
  attr_accessible :notification
  
  belongs_to :member
end
