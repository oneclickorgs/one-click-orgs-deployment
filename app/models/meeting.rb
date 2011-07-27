class Meeting < ActiveRecord::Base
  belongs_to :organisation
  
  has_many :meeting_participations
  has_many :participants, :through => :meeting_participations
  
  def to_event
    {:timestamp => created_at, :object => self, :kind => :meeting}
  end
  
  # This processes the parameters from a form of checkboxes,
  # where the names are the member IDs, and the values are
  # '1' when the checkbox is selected.
  def participant_ids=(participant_ids)
    participant_ids.keys.each do |participant_id|
      # TODO This member lookup should be scoped by organisation,
      # but at build time the Meeting object's 'organisation'
      # attribute is nil.
      participant = Member.find(participant_id)
      participants << participant
    end
  end
end
