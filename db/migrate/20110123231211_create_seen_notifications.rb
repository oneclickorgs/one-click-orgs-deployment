class CreateSeenNotifications < ActiveRecord::Migration
  def self.up
    create_table :seen_notifications do |t|
      t.integer :member_id
      t.string :notification

      t.timestamps
    end
    
    add_index(:seen_notifications, [:member_id, :notification])
  end

  def self.down
    remove_index(:seen_notifications, [:member_id, :notification])
    
    drop_table :seen_notifications
  end
end
