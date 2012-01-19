class AddCreatorIdToMeetings < ActiveRecord::Migration
  def self.up
    add_column :meetings, :creator_id, :integer
  end

  def self.down
    remove_column :meetings, :creator_id
  end
end