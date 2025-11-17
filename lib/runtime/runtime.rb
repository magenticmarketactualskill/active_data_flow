# frozen_string_literal: true

module ActiveDataflow
  module Runtime
    # Base class for runtime execution environments
    # Subclasses define how DataFlows are executed
    class Base
      attr_reader :config

      def initialize(config = {})
        @config = config
        validate_config!
      end

      # Execute a DataFlow
      # Subclasses must implement their execution strategy
      def execute(data_flow)
        raise NotImplementedError, "#{self.class} must implement #execute method"
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
