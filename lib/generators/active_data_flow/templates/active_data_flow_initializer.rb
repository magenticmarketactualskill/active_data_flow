# frozen_string_literal: true

# ActiveDataFlow Configuration
# Customize the behavior of ActiveDataFlow in your application

ActiveDataFlow.configure do |config|
  # Enable/disable automatic loading of data flows
  # When enabled, data flows in app/data_flows/ are automatically loaded and registered
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
