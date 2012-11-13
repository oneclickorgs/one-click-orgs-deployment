class AddDismissedAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :dismissed_at, :timestamp
  end
end
