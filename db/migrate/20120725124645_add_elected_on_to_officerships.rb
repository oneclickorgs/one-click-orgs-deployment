class AddElectedOnToOfficerships < ActiveRecord::Migration
  def change
    add_column :officerships, :elected_on, :date
  end
end
