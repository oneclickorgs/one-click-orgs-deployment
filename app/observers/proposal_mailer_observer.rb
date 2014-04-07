class ProposalMailerObserver < ActiveRecord::Observer
  # Rails (in development mode, at least) doesn't pre-load all the
  # model classes. In order to register this observer for all proposals,
  # we must explicitly observe each proposal sub-class.
  # TODO: Yuck. Is there a better way?
  observe :proposal,
    :add_member_proposal,
    :change_boolean_proposal,
    :change_member_class_proposal,
    :change_text_proposal,
    :change_voting_period_proposal,
    :change_voting_system_proposal,
    :constitution_proposal,
    :eject_member_proposal,
    :found_association_proposal,
    :membership_proposal,
    :resolution_proposal,
    :resolution,
    :board_resolution,
    :change_boolean_resolution,
    :change_integer_resolution,
    :change_meeting_notice_period_resolution,
    :change_quorum_resolution,
    :change_text_resolution,
    :terminate_directorship_resolution
  
  def after_create(proposal)
    send_notification_email(proposal)
  end
  
  # TODO If rejected, send a notification email
  # def after_transition(proposal, transition)
  # end
  
  def send_notification_email(proposal)
    notification_email_action = if proposal.respond_to?(:notification_email_action)
      proposal.notification_email_action
    else
      :notify_creation
    end
    
    members_to_notify = if proposal.respond_to?(:members_to_notify)
      proposal.members_to_notify
    else
      proposal.organisation.members.active
    end
    
    members_to_notify = members_to_notify.delete_if(&:blank?)
    
    members_to_notify.each do |m|
      # only notify members who can vote
      ProposalMailer.send(notification_email_action, m, proposal).deliver if m.has_permission(:vote)
    end
  end
end
