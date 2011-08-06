class AddStoodDownOnToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :stood_down_on, :date
  end

  def self.down
    remove_column :members, :stood_down_on
  end
end
