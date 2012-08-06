class ChangeTextResolution < Resolution
  attr_accessible :name, :value

  before_create :set_default_title
  def set_default_title
    self.title ||= "Change #{name.humanize.downcase} to '#{value}'"
  end

  def enact!
    organisation.clauses.set_text!(parameters['name'], parameters['value'])
  end

  validates_each :parameters do |record, attribute, value|
    if Clause.get_text(record.parameters['name']) == record.parameters['value']
      record.errors.add :base, "Proposal does not change the current clause"
    end
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
