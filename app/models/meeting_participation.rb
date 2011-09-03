class MeetingParticipation < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :participant, :class_name => 'Member'
end
