# Remove any founding members that did not vote in favour,
# and move organisation to 'active' state.
class FoundOrganisationProposal < Proposal
  validate :organisation_must_be_ready
  def organisation_must_be_ready
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
  
  def send_email
    # This one goes to all members (who are founding members)
    self.organisation.members.each do |m|
      # only notify members who can vote
      ProposalMailer.notify_foundation_proposal(m, self).deliver if m.has_permission(:vote)
    end
  end  
  
  def after_reject(params)
    organisation.pending! # Switching back to 'pending' org state.
    # The existence of a failed 'Found Organisation' proposal is the only record we keep of this.
  end
  
  def enact!
    # initial members are all founding members that didn't vote "no" (including 
    # members who abstained.)
    confirmed_member_ids = []
    votes.each do |v|
      confirmed_member_ids << v.member_id unless v.for? == false
    end
    
    organisation.members.each do |member|
      member.member_class = organisation.member_classes.find_by_name('Member')
      member.save!
      unless confirmed_member_ids.include?(member.id)
        member.eject! # Rather than destroying, so we can still send a goodbye message
      end
    end
    
    organisation.active!
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
