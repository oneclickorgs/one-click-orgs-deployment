class ChangeQuorumResolution < ExtraordinaryResolution
  attr_accessible :pass_immediately, :quorum_number, :quorum_percentage

  def quorum_number
    parameters['quorum_number']
  end

  def quorum_number=(new_quorum_number)
    self.parameters['quorum_number'] = new_quorum_number.to_i
  end

  def quorum_percentage
    parameters['quorum_percentage']
  end

  def quorum_percentage=(new_quorum_percentage)
    self.parameters['quorum_percentage'] = new_quorum_percentage.to_i
  end

  def set_default_title
    self.title ||= "Change quorum for General Meetings to the greater of #{quorum_number} members or #{quorum_percentage}% of the membership"
  end
end
