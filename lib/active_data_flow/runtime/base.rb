# frozen_string_literal: true

module ActiveDataFlow
  module Runtime
    class Base
      # Base class for all runtime implementations
      
      attr_reader :options
      
      def initialize(**options)
        @options = options
      end
      
      # Execute a data flow
      def execute(data_flow)
        raise NotImplementedError, "#{self.class} must implement #execute"
      end
      
      # Serialize to JSON
      def as_json(*_args)
        @options
      end
      
      # Deserialize from JSON
      def self.from_json(data)
        new(**data.symbolize_keys)
      end
    end
  end
end
