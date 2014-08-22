# When the members of an organisation decide they need to convene a General Meeting
# (perhaps because the board hasn't bothered to do it), they need to submit an application
# to the board signed by a certain number of members. A GeneralMeetingProposal represents
# this application.
class GeneralMeetingProposal < Proposal
  before_create :set_default_title
  def set_default_title
    self.title = 'Convene a General Meeting' unless self.title.present?
  end

  def voting_system
    VotingSystems.get(:TenPercentOrOneHundred)
  end

  def enact!
    organisation.secretary.tasks.create!(subject: self, action: :convene_general_meeting)
  end
end
