class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.integer :organisation_id
      t.string :title

      t.timestamps
    end
  end
end
