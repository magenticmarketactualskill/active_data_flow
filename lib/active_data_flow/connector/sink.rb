# frozen_string_literal: true

module ActiveDataFlow
  module Connector
    module Sink
      class Base
        # Base class for all sink connectors
        
        attr_reader :options
        
        def initialize(**options)
          @options = options
        end
        
        # Write a record to the sink
        def write(record)
          raise NotImplementedError, "#{self.class} must implement #write"
        end
        
        # Write multiple records to the sink
        def write_batch(records)
          records.each { |record| write(record) }
        end
        
        # Flush any buffered writes
        def flush
          # Override in subclasses if needed
        end
        
        # Close the sink and release resources
        def close
          flush
        end
        
        # Serialize to JSON
        def as_json(*_args)
          @options.merge('class_name' => self.class.name)
        end
        
        # Deserialize from JSON
        def self.from_json(data)
          new(**data.symbolize_keys)
        end
      end
    end
  end
end
