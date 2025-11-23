# frozen_string_literal: true

module ActiveDataFlow
  module Concerns
    class << self
      # Load all concerns from the engine
      def load_engine_concerns(engine_root)
        concerns_path = engine_root.join("app/data_flows/concerns/**/*.rb")
        load_concerns_from_path(concerns_path, "engine")
      end

      # Load all concerns from the host application
      def load_host_concerns(concerns_path)
        load_concerns_from_path(concerns_path, "host")
      end

      private

      def load_concerns_from_path(path, source)
        Dir[path].sort.each do |file|
          begin
            load file
            log_debug "Loaded #{source} concern: #{file}"
          rescue StandardError => e
            log_error "Failed to load #{source} concern #{file}: #{e.message}"
            log_error e.backtrace.join("\n") if debug_mode?
          end
        end
      end

      def log_debug(message)
        return unless Rails.logger && debug_mode?
        Rails.logger.debug(message)
      end

      def log_error(message)
        Rails.logger.error(message) if Rails.logger
      end

      def debug_mode?
        defined?(ActiveDataFlow.configuration) &&
          ActiveDataFlow.configuration.log_level == :debug
      end
    end
  end
end

# Auto-load engine concerns when this file is required
if defined?(Rails)
  engine_root = Pathname.new(File.expand_path("../..", __dir__))
  ActiveDataFlow::Concerns.load_engine_concerns(engine_root)
end
