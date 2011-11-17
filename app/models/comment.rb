class Comment < ActiveRecord::Base
  default_scope order("created_at ASC")
  
  belongs_to :proposal
  belongs_to :author, :class_name => 'Member', :foreign_key => 'author_id'
end
