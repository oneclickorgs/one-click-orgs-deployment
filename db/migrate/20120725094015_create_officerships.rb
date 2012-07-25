class CreateOfficerships < ActiveRecord::Migration
  def change
    create_table :officerships do |t|
      t.integer :office_id
      t.integer :officer_id

      t.timestamps
    end
  end
end
