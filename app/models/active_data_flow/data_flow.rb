# frozen_string_literal: true

# Backward compatibility: Alias to the backend-specific implementation
# This file maintains compatibility with existing code that references ActiveDataFlow::DataFlow

module ActiveDataFlow
  # Dynamically set the DataFlow constant based on configuration
  # This runs when the file is loaded
  case ActiveDataFlow.configuration.storage_backend
  when :active_record
    require_relative 'active_record/data_flow'
    DataFlow = ActiveDataFlow::ActiveRecord::DataFlow
  when :redcord_redis, :redcord_redis_emulator
    require_relative 'redcord/data_flow'
    DataFlow = ActiveDataFlow::Redcord::DataFlow
  else
    # Default to ActiveRecord
    require_relative 'active_record/data_flow'
    DataFlow = ActiveDataFlow::ActiveRecord::DataFlow
  end
end
