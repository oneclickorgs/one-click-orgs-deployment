class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.date :happened_on
      t.text :minutes

      t.timestamps
    end
  end

  def self.down
    drop_table :meetings
  end
end
