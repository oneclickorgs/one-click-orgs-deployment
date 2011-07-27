class CreateMeetingParticipations < ActiveRecord::Migration
  def self.up
    create_table :meeting_participations do |t|
      t.integer :meeting_id
      t.integer :participant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :meeting_participations
  end
end
