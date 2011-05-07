# Represents a proposal to change one of the free-text fields
# in the constitution; e.g. the organisation name, or the
# organisation objectives.
class ChangeTextProposal < Proposal

  def allows_direct_edit?
    true
  end

  def enact!(params)
    organisation.clauses.set_text!(params['name'], params['value'])
  end
  
  def voting_system
    organisation.constitution.voting_system(:constitution)
  end
  
  validates_each :parameters do |record, attribute, value|
    if Clause.get_text(record.parameters['name']) == record.parameters['value']
      record.errors.add :base, "Proposal does not change the current clause"
    end
  end
  
  def decision_notification_message
    "If you have previously printed/saved a PDF copy of the constitution, this prior copy is now out of date. Please consider reprinting/saving a copy of the latest constitution for your records."
  end
end
