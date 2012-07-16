class Meeting < ActiveRecord::Base
  attr_accessible :happened_on, :participant_ids, :minutes
  
  belongs_to :organisation
  
  validates_presence_of :organisation
  
  has_many :meeting_participations
  has_many :participants, :through => :meeting_participations
  
  belongs_to :creator, :class_name => 'Member', :foreign_key => 'creator_id'
  
  has_many :comments, :as => :commentable

  scope :upcoming, lambda{where(['happened_on > ?', Time.now.utc.midnight.advance(:days => 1)])}
  
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
    organisation.members.each do |member|
      MeetingMailer.notify_creation(member, self).deliver
    end
  end
end
