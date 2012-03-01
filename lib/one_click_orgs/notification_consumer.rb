module OneClickOrgs
  module NotificationConsumer
    extend ActiveSupport::Concern
    
    included do
      has_many :seen_notifications
    end
    
    # Check if this notification has been shown to user already.
    #
    # @param [Symbol] notification the kind of notification
    # @param [optional, Timestamp] ignore_earlier_than If you pass this timestamp, we only consider the period
    # after the timestamp when checking to see if the member has already seen this notification.
    def has_seen_notification?(notification, ignore_earlier_than = nil)
      if ignore_earlier_than
        seen_notifications.exists?(["notification = ? AND updated_at >= ?", notification, ignore_earlier_than])
      else
        seen_notifications.exists?(:notification => notification)
      end
    end

    def has_seen_notification!(notification)
      seen_notification = seen_notifications.find_by_notification(notification)
      if seen_notification
        seen_notification.touch
      else
        seen_notifications.create(:notification => notification)
      end
    end
  end
end
