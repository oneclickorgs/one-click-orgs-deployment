class CreateResignations < ActiveRecord::Migration
  def self.up
    create_table :resignations do |t|
      t.integer :member_id

      t.timestamps
    end
  end

  def self.down
    drop_table :resignations
  end
end
