# A ResolutionProposal is a proposed resolution. In other words, it is not
# a resolution itself, but rather it is a suggested resolution.
# It is created when a Member of a Co-op wants to suggest a Resolution.
# The ResolutionProposal is 'passed' if the Directors/Secretary agree
# to open the suggested resolution to a vote. At that point, the
# 'real' Resolution is created.
class ResolutionProposal < Proposal
  attr_accessor :create_draft_resolution

  def enact!
    @resolution = organisation.resolutions.build
    @resolution.proposer = proposer
    @resolution.description = description
    if create_draft_resolution
      @resolution.draft = true
    end
    @resolution.save!
  end

  def new_resolution
    @resolution
  end

  before_create :set_title
  def set_title
    if title.blank?
      self.title = description.truncate(200)
    end
  end
  
  def members_to_notify
    [organisation.secretary]
  end
  
  def notification_email_action
    :notify_resolution_proposal
  end
end
