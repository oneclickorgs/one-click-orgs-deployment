class AddClosingDatesToElections < ActiveRecord::Migration
  def change
    add_column :elections, :nominations_closing_date, :date
    add_column :elections, :voting_closing_date, :date
  end
end
