class AddDecimalValueToClauses < ActiveRecord::Migration
  def change
    add_column :clauses, :decimal_value, :decimal, :precision => 10, :scale => 5
  end
end
