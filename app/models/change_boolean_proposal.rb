# Represents a proposal to change one of the boolean fields
# in the constitution; e.g. the assets-holding
class ChangeBooleanProposal < ConstitutionProposal

  def allows_direct_edit?
    true
  end

  def enact!(params)
    organisation.clauses.set_boolean!(params['name'], params['value'])
  end
end
