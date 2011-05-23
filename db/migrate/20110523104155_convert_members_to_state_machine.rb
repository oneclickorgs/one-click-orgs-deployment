class ConvertMembersToStateMachine < ActiveRecord::Migration
  class Member < ActiveRecord::Base; end
  
  def self.up
    add_column :members, :state, :string
    
    Member.all.each do |member|
      if member.active == 0
        member.state = 'inactive'
      elsif member.inducted_at.nil?
        member.state = 'pending'
      else
        member.state = 'active'
      end
      member.save!
    end
    
    remove_column :members, :active
    
    # Not removing 'inducted_at' column, since we still want to keep a log of
    # when the member was inducted.
  end

  def self.down
    add_column :members, :active, :integer, :limit => 1, :default => 1
    
    Member.all.each do |member|
      if member.state == 'inactive'
        member.active = 0
      else
        member.active = 1
      end
      member.save!
    end
    
    remove_column :members, :state
  end
end
