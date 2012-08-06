class CreateDirectorships < ActiveRecord::Migration
  def change
    create_table :directorships do |t|
      t.references :organisation
      t.references :director
      t.date :elected_on
      t.date :ended_on
      t.timestamps
    end
  end
end
