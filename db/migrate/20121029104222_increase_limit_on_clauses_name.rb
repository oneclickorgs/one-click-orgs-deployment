class IncreaseLimitOnClausesName < ActiveRecord::Migration
  def change
    change_column :clauses, :name, :string, :limit => 255, :null => false
  end
end
