# The class FoundOrganisationProposal was renamed to FoundAssociationProposal in
# 3967f8a8dbdea4f8a6556e72f710dfc0639941c4. However, existing records in the `proposals`
# table still have the `type` column filled in with 'FoundOrganisationProposal'. To avoid
# `ActiveRecord::SubclassNotFound` errors, we need to rename them to match the new class
# name.
class ChangeFoundOrganisationProposalsToFoundAssociationProposals < ActiveRecord::Migration
  class Proposal < ActiveRecord::Base; end
  class FoundOrganisationProposal < Proposal; end
  class FoundAssociationProposal < Proposal; end

  def up
    Proposal.where(type: 'FoundOrganisationProposal').each do |p|
      p.type = 'FoundAssociationProposal'
      p.save!
    end
  end

  def down
    Proposal.where(type: 'FoundAssociationProposal').each do |p|
      p.type = 'FoundOrganisationProposal'
      p.save!
    end
  end
end
