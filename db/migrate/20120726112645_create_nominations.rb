class CreateNominations < ActiveRecord::Migration
  def change
    create_table :nominations do |t|
      t.integer :election_id
      t.integer :nominee_id
      t.timestamps
    end
  end
end
