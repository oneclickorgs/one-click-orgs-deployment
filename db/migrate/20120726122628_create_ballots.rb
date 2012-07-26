class CreateBallots < ActiveRecord::Migration
  def change
    create_table :ballots do |t|
      t.integer :election_id
      t.integer :member_id
      t.text :ranking
      t.timestamps
    end
  end
end
