class DecisionMailerObserver < ActiveRecord::Observer
  observe :decision
  
  def after_create(decision)
    send_notification_email(decision)
  end
  
protected
  
  def send_notification_email(decision)
    case decision.proposal
    when FoundAssociationProposal
      decision.organisation.members.each do |m|
        DecisionMailer.notify_foundation_decision(m, decision).deliver
      end
    else
      decision.organisation.members.active.each do |m|
        DecisionMailer.notify_new_decision(m, decision).deliver
      end
    end
  rescue => e
    Rails.logger.error("Error sending decision email: #{e.inspect}")
  end
end
