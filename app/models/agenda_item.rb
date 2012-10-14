class AgendaItem < ActiveRecord::Base
  attr_accessible :meeting_id, :minutes, :position, :title
end
