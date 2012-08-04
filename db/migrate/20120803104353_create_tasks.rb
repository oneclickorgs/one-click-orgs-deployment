class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :member_id
      t.integer :subject_id
      t.string :subject_type
      t.string :action
      t.timestamp :completed_at
      t.timestamps
    end
  end
end
