class AddOrganisationIdToMeetings < ActiveRecord::Migration
  def self.up
    add_column :meetings, :organisation_id, :integer
  end

  def self.down
    remove_column :meetings, :organisation_id
  end
end