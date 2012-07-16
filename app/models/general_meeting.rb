class GeneralMeeting < Meeting
  attr_accessible :start_time, :venue, :agenda, :certification

  attr_accessor :certification
end
