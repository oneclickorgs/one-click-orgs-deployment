class ExtraordinaryResolution < Resolution
  def voting_system
    VotingSystems.get(:AbsoluteThreeQuartersMajority)
  end
end
