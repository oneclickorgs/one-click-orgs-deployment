class AddForeignKeyIndexesToTables < ActiveRecord::Migration
  def self.up
    add_index :members, :organisation_id
    add_index :member_classes, :organisation_id
    add_index :clauses, :organisation_id
    add_index :seen_notifications, :member_id
    add_index :votes, [:proposal_id,:member_id]
    add_index :comments, [:proposal_id,:author_id]
    add_index :decisions, :proposal_id
  end

  def self.down
    remove_index :votes, [:proposal_id,:member_id]
    remove_index :seen_notifications, :member_id
    remove_index :clauses, :organisation_id

    remove_index :member_classes, :organisation_id
    remove_index :members, :organisation_id
    remove_index :comments, [:proposal_id,:author_id]
    remove_index :decisions, :proposal_id
  end
end