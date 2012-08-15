class AddSeatsToElections < ActiveRecord::Migration
  def change
    add_column :elections, :seats, :integer
  end
end
