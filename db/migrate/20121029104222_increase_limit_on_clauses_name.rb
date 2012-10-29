class IncreaseLimitOnClausesName < ActiveRecord::Migration
  def self.up
    change_column :clauses, :name, :string, :limit => 255, :null => false
  end

  def self.down
    change_column :clauses, :name, :string, :limit => 50, :null => false
  end
end
