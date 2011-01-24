# A SeenNotification is created when a particular member has seen a particular
# notification, so that we can avoid showing it to them again.
class SeenNotification < ActiveRecord::Base
  belongs_to :member
end
