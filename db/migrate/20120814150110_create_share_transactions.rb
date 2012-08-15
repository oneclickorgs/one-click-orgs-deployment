class CreateShareTransactions < ActiveRecord::Migration
  def change
    create_table :share_transactions do |t|
      t.string :state
      t.integer :amount
      t.references :from_account
      t.references :to_account
      t.integer :share_value

      t.timestamps
    end
  end
end
