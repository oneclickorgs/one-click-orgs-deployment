class AddElectedOnToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :elected_on, :date
  end

  def self.down
    remove_column :members, :elected_on
  end
end