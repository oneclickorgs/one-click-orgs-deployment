# Remove any founding members that did not vote in favour,
# and move organisation to 'active' state.
class FoundOrganisationProposal < Proposal

  def send_email
    # This one goes to all members (who are founding members)
    self.organisation.members.each do |m|
      # only notify members who can vote
      ProposalMailer.notify_foundation_proposal(m, self).deliver if m.has_permission(:vote)
    end
  end  
  
  def reject!(params)
    organisation.pending! # Switching back to 'pending' org state.
    # The existence of a failed 'Found Organisation' proposal is the only record we keep of this.
  end
  
  def enact!(params)
    # initial members are all founding members that didn't vote "no" (including 
    # members who abstained.)
    confirmed_member_ids = []
    Vote.all.each do |v|
      confirmed_member_ids << v.member_id unless v.for? == false
    end
    
    organisation.members.each do |member|
      if confirmed_member_ids.include?(member.id)
        member.member_class = organisation.member_classes.find_by_name('Member')
        member.save!
      else
        #member.destroy
        member.eject! # So we can still send a goodbye message
      end
    end
    
    organisation.active!
    organisation.save
  end
  
  def voting_system
    VotingSystems.get('Founding')
  end
  
  def member_count
    organisation.members.count
  end
end
