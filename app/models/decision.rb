class Decision < ActiveRecord::Base
  belongs_to :proposal
  
  def organisation
    proposal.organisation if proposal
  end
  
  def to_event
    { :timestamp => self.proposal.close_date, :object => self, :kind => :decision }    
  end 
  
  def send_email
    # TODO this should be checking the class of the Proposal, not the voting system used
    if proposal.voting_system==VotingSystems.get('Founding') then
      # Decision on the Founding Proposal.
      # At this point the proposal has already been enacted.
      self.organisation.members.each do |m|
        DecisionMailer.notify_foundation_decision(m, self).deliver
      end
    else
      self.organisation.members.active.each do |m|
        DecisionMailer.notify_new_decision(m, self).deliver
      end
    end
  rescue => e
    Rails.logger.error("Error sending decision email: #{e.inspect}")
  end
  
  # only to be backwards compatible with systems running older versions of delayed job
  def self.send_email_for(decision_id)
    Decision.find(decision_id).send_email_without_send_later
  end
  
  after_create :send_email
end
