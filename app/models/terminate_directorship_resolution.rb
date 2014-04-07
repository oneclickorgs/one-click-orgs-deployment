class TerminateDirectorshipResolution < Resolution
  attr_accessible :director_id

  validates_presence_of :organisation

  validates_each :parameters do |record, attribute, value|
    unless record.organisation.directorships.find_by_id(record.directorship_id)
      record.errors.add :base, 'The directorship belongs to a different organisation'
    end
  end

  def director_id
    return nil if parameters['directorship_id'].blank?
    director.id
  end

  def director_id=(new_director_id)
    director = Member.find(new_director_id)
    raise "Could not find a directorship for director ID #{new_director_id}" unless director.directorship
    self.directorship = director.directorship
  end

  def directorship
    return nil if parameters['directorship_id'].blank?
    organisation.directorships.find(parameters['directorship_id'])
  end

  def directorship=(new_directorship)
    parameters['directorship_id'] = new_directorship.id
  end

  def directorship_id
    parameters['directorship_id']
  end

  def directorship_id=(new_directorship_id)
    parameters['directorship_id'] = new_directorship_id
  end

  def director
    return nil if parameters['directorship_id'].blank?
    directorship.director
  end

  def set_default_title
    self.title ||= "Terminate #{director.name}'s appointment as a director"
  end

  def enact!
    directorship = self.directorship
    directorship.ended_on = Time.now.utc
    directorship.save!
  end
end
