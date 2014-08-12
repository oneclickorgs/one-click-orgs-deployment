class RenameNominationsVotesToVoteTotal < ActiveRecord::Migration
  def up
    rename_column('nominations', 'votes', 'vote_total')
  end

  def down
    rename_column('nominations', 'vote_total', 'votes')
  end
end
