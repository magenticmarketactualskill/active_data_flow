# frozen_string_literal: true

module ActiveDataflow
  module Message
    # Typed message with schema validation
    # Ensures data conforms to a defined schema
    class Typed
      attr_reader :data, :schema, :metadata

      def initialize(data, schema:, metadata: {})
        @schema = schema
        @metadata = metadata
        validate_data!(data)
        @data = data
      end

      def [](key)
        data[key]
      end

      def []=(key, value)
        validate_field!(key, value)
        data[key] = value
      end

      def to_h
        { data: data, schema: schema, metadata: metadata }
      end

      private

      def validate_data!(data)
        return unless schema

        schema.each do |field, type|
          next unless data.key?(field)
          validate_field!(field, data[field])
        end
      end

      def validate_field!(field, value)
        return unless schema && schema.key?(field)

        expected_type = schema[field]
        unless value.is_a?(expected_type)
          raise TypeError, "Field '#{field}' must be of type #{expected_type}, got #{value.class}"
        end
      end
    end
  end
end
