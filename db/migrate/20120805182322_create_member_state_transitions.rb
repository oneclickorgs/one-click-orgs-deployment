class CreateMemberStateTransitions < ActiveRecord::Migration
  def change
    create_table :member_state_transitions do |t|
      t.references :member
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_index :member_state_transitions, :member_id
  end
end
