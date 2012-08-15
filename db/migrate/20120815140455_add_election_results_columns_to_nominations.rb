class AddElectionResultsColumnsToNominations < ActiveRecord::Migration
  def change
    add_column :nominations, :state, :string
    add_column :nominations, :votes, :decimal, :precision => 15, :scale => 10
  end
end
