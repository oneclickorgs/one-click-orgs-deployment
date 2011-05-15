# Represents a proposal to change one of the boolean fields
# in the constitution; e.g. the assets-holding
class ChangeBooleanProposal < ConstitutionProposal
  def enact!(params)
    organisation.clauses.set_boolean!(params['name'], params['value'])
  end
  
  def name
    parameters['name']
  end
  
  def name=(name)
    parameters['name'] = name
  end
  
  def value
    parameters['value']
  end
  
  def value=(value)
    parameters['value'] = value
  end
end
