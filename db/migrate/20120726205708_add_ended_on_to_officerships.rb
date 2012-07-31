class AddEndedOnToOfficerships < ActiveRecord::Migration
  def change
    add_column :officerships, :ended_on, :date
  end
end
