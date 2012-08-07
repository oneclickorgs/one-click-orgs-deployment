class Meeting < ActiveRecord::Base
  attr_accessible :happened_on, :participant_ids, :minutes

  belongs_to :organisation

  validates_presence_of :organisation

  has_many :meeting_participations
  has_many :participants, :through => :meeting_participations

  belongs_to :creator, :class_name => 'Member', :foreign_key => 'creator_id'

  has_many :comments, :as => :commentable

  # 'Upcoming' scope includes meetings happening today.
  scope :upcoming, lambda{where(['happened_on >= ?', Time.now.utc.to_date])}

  scope :past, lambda{where(['happened_on < ?', Time.now.utc.to_date])}

  def to_event
    {:timestamp => created_at, :object => self, :kind => :meeting}
  end

  # This processes the parameters from a form of checkboxes,
  # where the names are the member IDs, and the values are
  # '1' when the checkbox is selected.
  def participant_ids=(participant_ids)
    unless organisation
      raise RuntimeError, "Organisation must be set before setting participant IDs"
    end

    participant_ids.keys.each do |participant_id|
      participant = organisation.members.find_by_id(participant_id)
      participants << participant if participant
    end
  end

  after_create :send_creation_notification_emails
  def send_creation_notification_emails
    if creation_notification_email_action && members_to_notify
      members_to_notify.each do |member|
        MeetingMailer.send(creation_notification_email_action, member, self).deliver
      end
    end
  end

  def past?
    happened_on && happened_on < Time.now.utc.to_date
  end

  def creation_notification_email_action
    :notify_creation
  end

  def members_to_notify
    organisation.members
  end
end
