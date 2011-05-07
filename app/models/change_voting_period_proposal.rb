# Represents a proposal to change the voting period for propsosals.
class ChangeVotingPeriodProposal < Proposal

  def allows_direct_edit?
    true
  end

  def enact!(params)
    organisation.constitution.change_voting_period(params['new_voting_period'].to_i)
  end
  
  def decision_notification_message
    "If you have previously printed/saved a PDF copy of the constitution, this prior copy is now out of date. Please consider reprinting/saving a copy of the latest constitution for your records."
  end
end
