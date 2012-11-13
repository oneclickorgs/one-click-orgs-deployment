# Remove any founding members that did not vote in favour,
# and move association to 'active' state.
class FoundAssociationProposal < Proposal
  validate :association_must_be_ready
  def association_must_be_ready
    if new_record? && !organisation.can_hold_founding_vote?
      errors.add(:base, "Organisation not ready to hold founding vote")
    end
  end

  before_create :set_default_title
  def set_default_title
    self.title ||= "Proposal to found #{organisation.name}"
  end

  before_create :set_default_description
  def set_default_description
    self.description ||= "Found #{organisation.name}"
  end

  def notification_email_action
    :notify_foundation_proposal
  end

  def members_to_notify
    organisation.members
  end

  def after_reject(params)
    organisation.reject_founding! # Switching back to 'pending' org state.
    # The existence of a failed 'Found Association' proposal is the only record we keep of this.
  end

  def enact!
    # initial members are all founding members that didn't vote "no" (including
    # members who abstained.)
    confirmed_member_ids = []
    votes.each do |v|
      confirmed_member_ids << v.member_id if v.for?
    end

    organisation.members.each do |member|
      member.member_class = organisation.member_classes.find_by_name('Member')
      member.save!

      if confirmed_member_ids.include?(member.id)
        member.induct!
      else
        member.eject! # Rather than destroying, so we can still send a goodbye message
      end
    end

    organisation.found!
    organisation.save
  end

  def voting_system
    VotingSystems.get('Founding')
  end

  def voting_period
    60 * 60 * 24 * 3 # Founding vote period is fixed at three days.
  end

  def member_count
    organisation.members.count
  end

  def automatic_proposer_support_vote?
    false
  end
end
