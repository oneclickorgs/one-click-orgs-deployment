class AddMeetingIdToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :meeting_id, :integer
  end
end
