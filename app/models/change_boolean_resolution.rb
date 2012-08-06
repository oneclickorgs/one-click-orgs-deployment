class ChangeBooleanResolution < Resolution
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
