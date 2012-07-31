class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.integer :organisation_id
      t.string :state
      t.timestamps
    end
  end
end
