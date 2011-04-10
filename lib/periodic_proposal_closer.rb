class PeriodicProposalCloser
  def perform
    Proposal.close_proposals
    Delayed::Job.enqueue(PeriodicProposalCloser.new, :priority => 0, :run_at => 60.seconds.from_now)
  end
end
