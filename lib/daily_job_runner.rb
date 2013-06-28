class DailyJobRunner
  def perform
    Coop.run_daily_job
    Resolution.run_daily_job
    ShareTransaction.run_daily_job

    Delayed::Job.enqueue(DailyJobRunner.new, :priority => 0, :run_at => 1.day.from_now)
  end
end
