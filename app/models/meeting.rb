class Meeting < ActiveRecord::Base
  attr_accessible :happened_on, :participant_ids, :minutes, :agenda_items_attributes

  attr_reader :participant_ids

  belongs_to :organisation

  validates_presence_of :organisation

  has_many :meeting_participations
  has_many :participants, :through => :meeting_participations

  belongs_to :creator, :class_name => 'Member', :foreign_key => 'creator_id'

  has_many :comments, :as => :commentable

  has_many :agenda_items

  accepts_nested_attributes_for :agenda_items

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

  before_save :build_participants_from_participant_ids
  def build_participants_from_participant_ids
    return unless participant_ids

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
end
