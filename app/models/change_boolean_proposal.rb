# Represents a proposal to change one of the boolean fields
# in the constitution; e.g. the assets-holding
class ChangeBooleanProposal < Proposal

  def allows_direct_edit?
    true
  end

  def enact!(params)
    organisation.clauses.set_boolean!(params['name'], params['value'])
  end
  
  def voting_system
    organisation.constitution.voting_system(:constitution)
  end
  
  def decision_notification_message
    "If you have previously printed/saved a PDF copy of the constitution, this prior copy is now out of date. Please consider reprinting/saving a copy of the latest constitution for your records."
  end
end
