class Meeting < ActiveRecord::Base
  attr_accessible :happened_on, :participant_ids, :minutes, :agenda_items_attributes

  belongs_to :organisation

  validates_presence_of :organisation

  has_many :meeting_participations
  has_many :participants, :through => :meeting_participations

  belongs_to :creator, :class_name => 'Member', :foreign_key => 'creator_id'

  has_many :comments, :as => :commentable

  has_many :agenda_items

  accepts_nested_attributes_for :agenda_items, :reject_if => :all_blank

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
    @participant_ids = participant_ids
  end

  def participant_ids
    @participant_ids ||= participants.map(&:id)
  end

  before_save :build_participants_from_participant_ids
  def build_participants_from_participant_ids
    return unless participant_ids && participant_ids.respond_to?(:keys)

    unless organisation
      raise RuntimeError, "Tried to save participant_ids without setting organisation"
      return
    end

    participant_ids.keys.each do |participant_id|
      participant = organisation.members.find_by_id(participant_id)
      participants << participant if participant
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

  # A Meeting is minuted if all of its agenda items have been minuted,
  # or, if it has no agenda items, if the 'minutes' attribute is present.
  def minuted?
    if agenda_items.present?
      agenda_items.inject(true){|memo, agenda_item| memo && agenda_item.minutes.present?}
    else
      minutes.present?
    end
  end
end
