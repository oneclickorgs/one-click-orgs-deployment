class CreateShareAccounts < ActiveRecord::Migration
  def change
    create_table :share_accounts do |t|
      t.integer :owner_id
      t.string :owner_type
      t.integer :balance

      t.timestamps
    end
  end
end
