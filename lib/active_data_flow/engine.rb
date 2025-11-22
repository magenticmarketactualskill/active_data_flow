# frozen_string_literal: true

require "rails"

module ActiveDataFlow
  class Engine < ::Rails::Engine
    isolate_namespace ActiveDataFlow

    # Add engine's concerns to autoload paths
    config.autoload_paths << root.join("app/data_flows/concerns")

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end

    initializer "active_data_flow.assets" do |app|
      app.config.assets.paths << root.join("app/assets")
      app.config.assets.precompile += %w[active_data_flow_manifest.js]
    end

    # Load concerns and data flows AFTER application initialization
    # This ensures all dependencies are loaded before data flows
    # Data flows are NOT loaded during Rails::Application#initialize
    config.after_initialize do
      # Skip if auto-loading is disabled
      next unless ActiveDataFlow.configuration.auto_load_data_flows

      # Use to_prepare to reload in development mode
      Rails.application.config.to_prepare do
        # First, load concerns from the engine
        engine_concerns_path = root.join("app/data_flows/concerns/**/*.rb")
        Dir[engine_concerns_path].sort.each do |file|
          load file
        end

        # Then, load concerns from host application
        host_concerns_path = Rails.root.join(ActiveDataFlow.configuration.data_flows_path, "concerns/**/*.rb")
        Dir[host_concerns_path].sort.each do |file|
          load file
        end

        # Finally, load data flows from host application
        # Only load if the directory exists and auto-loading is enabled
        data_flows_dir = Rails.root.join(ActiveDataFlow.configuration.data_flows_path)
        if Dir.exist?(data_flows_dir)
          data_flows_path = data_flows_dir.join("**/*_flow.rb")
          Dir[data_flows_path].sort.each do |file|
            begin
              load file
              log_message = "Loaded data flow: #{file}"
              case ActiveDataFlow.configuration.log_level
              when :debug
                Rails.logger.debug(log_message) if Rails.logger
              when :info
                Rails.logger.info(log_message) if Rails.logger
              end
            rescue StandardError => e
              Rails.logger.error "Failed to load data flow #{file}: #{e.message}" if Rails.logger
              Rails.logger.error e.backtrace.join("\n") if Rails.logger && ActiveDataFlow.configuration.log_level == :debug
            end
          end
        end
      end
    end
  end
end
