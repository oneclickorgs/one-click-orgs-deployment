require File.join(Rails.root, '/lib/periodic_proposal_closer')
require File.join(Rails.root, '/lib/daily_job_runner')

# HACKTASTIC.
begin
  unless Delayed::Job.where(["handler LIKE ?", "%PeriodicProposalCloser%"]).count > 0
    Delayed::Job.enqueue(PeriodicProposalCloser.new)
  end
  unless Delayed::Job.where(["handler LIKE ?", "%DailyJobRunner%"]).count > 0
    Delayed::Job.enqueue(DailyJobRunner.new)
  end
rescue
end
