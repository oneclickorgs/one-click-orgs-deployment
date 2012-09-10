# A ResolutionProposal is a proposed resolution. In other words, it is not
# a resolution itself, but rather it is a suggested resolution.
# It is created when a Member of a Co-op wants to suggest a Resolution.
# The ResolutionProposal is 'passed' if the Directors/Secretary agree
# to open the suggested resolution to a vote. At that point, the
# 'real' Resolution is created.
class ResolutionProposal < Proposal
  attr_accessible :resolution_class, :resolution_parameters

  attr_accessor :create_draft_resolution

  def enact!
    begin
      klass = resolution_class.constantize
    rescue NoMethodError, NameError
      klass = Resolution
    end

    @resolution = klass.new

    @resolution.organisation = organisation

    @resolution.proposer = proposer
    @resolution.title = title
    @resolution.description = description

    if resolution_parameters.present?
      resolution_parameters.each do |k, v|
        @resolution.send("#{k}=", v)
      end
    end

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
    return if title.present?

    if description.present?
      self.title = description.truncate(200)
    elsif resolution_class.present?
      self.title = resolution_class.constantize.new(resolution_parameters).set_default_title
    end
  end

  def members_to_notify
    [organisation.secretary]
  end

  def notification_email_action
    :notify_resolution_proposal
  end

  def to_event
    {:timestamp => self.creation_date, :object => self, :kind => :resolution_proposal }
  end

  def automatic_proposer_support_vote?
    false
  end

  def voting_system
    VotingSystems.get(:TenPercentOrOneHundred)
  end

  # Parameters

  def resolution_class
    parameters['resolution_class']
  end

  def resolution_class=(new_resolution_class)
    parameters['resolution_class'] = new_resolution_class
  end

  def resolution_parameters
    parameters['resolution_parameters'] || {}
  end

  def resolution_parameters=(new_resolution_parameters)
    parameters['resolution_parameters'] = new_resolution_parameters
  end
end
