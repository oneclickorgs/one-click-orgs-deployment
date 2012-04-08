# Represents a proposal to change one of the boolean fields
# in the constitution; e.g. the assets-holding
class ChangeBooleanProposal < ConstitutionProposal
  attr_accessible :name, :value
  
  def enact!
    organisation.clauses.set_boolean!(parameters['name'], parameters['value'])
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
