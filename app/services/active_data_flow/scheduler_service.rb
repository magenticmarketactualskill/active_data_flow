# frozen_string_literal: true

module ActiveDataFlow
  class SchedulerService
    def self.run_due_flows
      new.run_due_flows
    end

    def run_due_flows
      ActiveDataFlow::Scheduler.next_heartbeat
    end

    def cleanup_old_runs(older_than: 30.days.ago)
      DataFlowRun.where(created_at: ..older_than).delete_all
    end
  end
end