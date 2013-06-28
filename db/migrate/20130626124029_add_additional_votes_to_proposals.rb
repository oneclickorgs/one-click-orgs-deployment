class AddAdditionalVotesToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :additional_votes_for, :integer
    add_column :proposals, :additional_votes_against, :integer
  end
end
