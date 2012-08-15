class CreateShareTransactionStateTransitions < ActiveRecord::Migration
  def change
    create_table :share_transaction_state_transitions do |t|
      t.references :share_transaction
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_index :share_transaction_state_transitions, :share_transaction_id, :name => 'share_trans_state_trans_on_share_trans_id'
  end
end
