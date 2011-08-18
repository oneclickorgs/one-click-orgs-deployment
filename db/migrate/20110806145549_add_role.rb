class AddRole < ActiveRecord::Migration
  def self.up
    add_column :members, :role, :string
  end



  def self.down
  end
end
