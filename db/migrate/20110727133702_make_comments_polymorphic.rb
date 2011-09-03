class MakeCommentsPolymorphic < ActiveRecord::Migration
  class Comment < ActiveRecord::Base; end
  
  def self.up
    remove_index :comments, :name => "index_comments_on_proposal_id_and_author_id"
    
    add_column :comments, :commentable_type, :string
    rename_column :comments, :proposal_id, :commentable_id
    
    Comment.update_all(:commentable_type => "Proposal")
    
    add_index :comments, [:commentable_type, :commentable_id]
  end

  def self.down
    remove_index :comments, [:commentable_type, :commentable_id]
    rename_column :comments, :commentable_id, :proposal_id
    remove_column :comments, :commentable_type
    add_index :comments, [:proposal_id, :author_id], :name => "index_comments_on_proposal_id_and_author_id"
  end
end