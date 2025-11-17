# frozen_string_literal: true

module ActiveDataflow
  module Connector
    module Sink
      # Base class for data sinks
      # Subclasses must implement the #write method to persist records
      class Base
        attr_reader :config

        def initialize(config = {})
          @config = config
          validate_config!
        end

        # Writes a record to the sink
        # Subclasses must implement this method
        def write(record)
          raise NotImplementedError, "#{self.class} must implement #write method"
        end

        private

        # Override in subclasses to validate required configuration
        def validate_config!
          # Base implementation does nothing
        end

        # Helper method for subclasses to require config keys
        def require_config_keys(*keys)
          missing = keys - config.keys
          unless missing.empty?
            raise ArgumentError, "Missing required configuration keys: #{missing.join(', ')}"
          end
        end
      end
    end
  end
end
