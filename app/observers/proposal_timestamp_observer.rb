class ProposalTimestampObserver < ActiveRecord::Observer
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

  
  def before_create(proposal)
    set_creation_date(proposal)
    set_close_date(proposal)
  end
  
  def before_transition(proposal, transition)
    case transition.event
    when :close
      set_close_date_to_now(proposal)
    end
  end
  
  def after_transition(proposal, transition)
    case transition.event
    when :start
      set_close_date(proposal, true)
    end
  end
  
protected

  def set_creation_date(proposal)
    proposal.creation_date ||= Time.now.utc
  end
  
  def set_close_date(proposal, save=false)
    unless proposal.state == 'draft'
      proposal.close_date ||= Time.now.utc + proposal.voting_period
    end
    proposal.save if save
  end
  
  def set_close_date_to_now(proposal)
    proposal.close_date = Time.now.utc
    proposal.save!
  end
end
