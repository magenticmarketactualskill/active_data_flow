# frozen_string_literal: true

# Backward compatibility: Alias to the backend-specific implementation
# This file maintains compatibility with existing code that references ActiveDataFlow::DataFlowRun

module ActiveDataFlow
  # Dynamically set the DataFlowRun constant based on configuration
  # This runs when the file is loaded
  case ActiveDataFlow.configuration.storage_backend
  when :active_record
    require_relative 'active_record/data_flow_run'
    DataFlowRun = ActiveDataFlow::ActiveRecord::DataFlowRun
  when :redcord_redis, :redcord_redis_emulator
    require_relative 'redcord/data_flow_run'
    DataFlowRun = ActiveDataFlow::Redcord::DataFlowRun
  else
    # Default to ActiveRecord
    require_relative 'active_record/data_flow_run'
    DataFlowRun = ActiveDataFlow::ActiveRecord::DataFlowRun
  end
end
