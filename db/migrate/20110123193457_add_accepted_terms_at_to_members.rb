class AddAcceptedTermsAtToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :terms_accepted_at, :timestamp
  end

  def self.down
    remove_column :members, :terms_accepted_at
  end
end