class ConvertProposalsToStateMachine < ActiveRecord::Migration
  class ::Proposal < ActiveRecord::Base; end

  # Old databases being migrated from v1.x may have old class names in the
  # 'type' column, which causes an error when running this migration.
  # Temporarily define this class to work around this error.
  class ::FoundOrganisationProposal < Proposal; end

  def self.up
    add_column :proposals, :state, :string
    
    Proposal.all.each do |proposal|
      if proposal.accepted == 1
        proposal.state = "accepted"
      elsif proposal.open == 1
        proposal.state = "open"
      else
        proposal.state = "rejected"
      end
      proposal.save!(:validate => false)
    end
    
    remove_column :proposals, :open
    remove_column :proposals, :accepted
  end

  def self.down
    add_column :proposals, :accepted, :integer, :limit => 1, :default => 0
    add_column :proposals, :open, :integer,     :limit => 1, :default => 1
    
    Proposal.all.each do |proposal|
      case proposal.state
      when "accepted"
        proposal.open = 0
        proposal.accepted = 1
      when "open"
        proposal.open = 1
        proposal.accepted = 0
      when "rejected"
        proposal.open = 0
        proposal.accepted = 0
      end
      proposal.save!
    end
    
    remove_column :proposals, :state
  end
end
