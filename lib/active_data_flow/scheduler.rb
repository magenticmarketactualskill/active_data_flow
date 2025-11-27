# frozen_string_literal: true

module ActiveDataFlow
  module Scheduler
    autoload :Startup, 'active_data_flow/scheduler/startup'
    autoload :NextHeartbeat, 'active_data_flow/scheduler/next_heartbeat'

    def self.startup(engine_root)
      Startup.call(engine_root)
    end

    def self.next_heartbeat
      NextHeartbeat.call
    end
  end
end