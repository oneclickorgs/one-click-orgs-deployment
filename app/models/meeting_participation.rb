class MeetingParticipation < ActiveRecord::Base
  attr_accessible :participant_id
  
  belongs_to :meeting
  belongs_to :participant, :class_name => 'Member'
end
