class AddMeetingIdToElections < ActiveRecord::Migration
  def change
    add_column :elections, :meeting_id, :integer
  end
end
