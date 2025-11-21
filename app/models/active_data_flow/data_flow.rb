# frozen_string_literal: true

module ActiveDataFlow
  class DataFlow < ApplicationRecord
    # Model representing a registered data flow
    # Stores actual source, sink, and runtime instances as serialized objects
    
    # Custom serializer that stores objects as JSON with class info
    class ObjectSerializer
      def self.dump(obj)
        return nil if obj.nil?
        {
          class: obj.class.name,
          data: obj.as_json
        }.to_json
      end

      def self.load(json)
        return nil if json.nil?
        data = JSON.parse(json)
        klass = Object.const_get(data["class"])
        klass.from_json(data["data"])
      rescue NameError, JSON::ParserError
        nil
      end
    end
    
    serialize :source, ObjectSerializer
    serialize :sink, ObjectSerializer
    serialize :runtime, ObjectSerializer
    
    validates :name, presence: true, uniqueness: true
    validates :source, presence: true
    validates :sink, presence: true
    
    def self.find_or_create(name:, source:, sink:, runtime:)
      find_or_create_by(name: name) do |data_flow|
        data_flow.source = source
        data_flow.sink = sink
        data_flow.runtime = runtime
      end
    end
    
    def source_type
      source&.class&.name
    end
    
    def sink_type
      sink&.class&.name
    end
    
    def runtime_type
      runtime&.class&.name
    end
  end
end
