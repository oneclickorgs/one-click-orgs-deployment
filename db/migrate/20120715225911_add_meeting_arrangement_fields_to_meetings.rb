class AddMeetingArrangementFieldsToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :start_time, :string
    add_column :meetings, :venue, :text
    add_column :meetings, :agenda, :text
  end
end
