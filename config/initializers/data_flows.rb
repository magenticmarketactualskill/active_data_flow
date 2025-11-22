# frozen_string_literal: true

# ActiveDataFlow Configuration
# Data flows are automatically loaded AFTER Rails initialization completes
# This ensures all dependencies are available before loading data flows

ActiveDataFlow.configure do |config|
  # Enable/disable automatic loading of data flows
  # Default: true
  config.auto_load_data_flows = true

  # Set log level for data flow loading
  # Options: :debug, :info, :warn, :error
  # Default: :info
  config.log_level = :info

  # Set the path where data flows are located
  # Default: "app/data_flows"
  config.data_flows_path = "app/data_flows"
end