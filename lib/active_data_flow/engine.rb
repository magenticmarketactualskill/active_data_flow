# frozen_string_literal: true

require "rails"

module ActiveDataFlow
  class Engine < ::Rails::Engine
    isolate_namespace ActiveDataFlow

    # Add engine's concerns to autoload and eager load paths
    config.autoload_paths << root.join("app/data_flows/concerns")
    config.eager_load_paths << root.join("app/data_flows/concerns")

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end

    initializer "active_data_flow.assets" do |app|
      app.config.assets.paths << root.join("app/assets")
      app.config.assets.precompile += %w[active_data_flow_manifest.js]
    end

    # Register data flows after ActiveRecord is available
    # This runs in the host application context
    initializer "active_data_flow.register_data_flows", after: :load_config_initializers do
      # Capture the engine root for use in the callback
      engine_root = root
      
      ActiveSupport.on_load(:active_record) do
        Rails.application.config.after_initialize do
          # Skip if auto-loading is disabled
          next unless ActiveDataFlow.configuration.auto_load_data_flows

          # Use to_prepare to reload in development mode
          Rails.application.config.to_prepare do
            # Load concerns using the centralized loader
            ActiveDataFlow::Concerns.load_engine_concerns(engine_root)
            
            # Load host concerns and data flows
            data_flows_dir = Rails.root.join(ActiveDataFlow.configuration.data_flows_path)
            
            if Dir.exist?(data_flows_dir)
              # Load host concerns
              concerns_path = data_flows_dir.join("concerns/**/*.rb")
              ActiveDataFlow::Concerns.load_host_concerns(concerns_path)

              # Load and register data flows
              data_flows_path = data_flows_dir.join("**/*_flow.rb")
              Dir[data_flows_path].sort.each do |file|
                begin
                  load file
                  
                  # Extract class name from file path
                  class_name = File.basename(file, ".rb").camelize
                  
                  # Try to register the data flow if it has a register method
                  if Object.const_defined?(class_name)
                    flow_class = Object.const_get(class_name)
                    
                    if flow_class.respond_to?(:register)
                      flow_class.register
                      log_message = "Registered data flow: #{class_name}"
                      case ActiveDataFlow.configuration.log_level
                      when :debug, :info
                        Rails.logger.info(log_message) if Rails.logger
                      end
                    end
                  end
                  
                rescue StandardError => e
                  Rails.logger.error "Failed to load/register data flow #{file}: #{e.message}" if Rails.logger
                  Rails.logger.error e.backtrace.join("\n") if Rails.logger && ActiveDataFlow.configuration.log_level == :debug
                end
              end
            end
          end
        end
      end
    end
  end
end
