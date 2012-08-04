class AddStartsOnToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :starts_on, :date
  end
end
