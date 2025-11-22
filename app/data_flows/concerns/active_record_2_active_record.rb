# frozen_string_literal: true

module ActiveDataFlow
  module ActiveRecord2ActiveRecord
    extend ActiveSupport::Concern

    included do
      class_attribute :source_connector, :sink_connector, :runtime_runner
      class_attribute :data_flow_instance
    end

    class_methods do
      # Define the source for this data flow
      # @param scope [ActiveRecord::Relation] The scope to read from
      # @param config [Hash] Configuration options
      # @option config [Integer] :batch_size Batch size for iteration
      # @option config [Array] :scope_params Parameters for named scopes
      def source(scope, config = {})
        self.source_connector = ActiveDataFlow::Connector::Source::ActiveRecordSource.new(
          scope: scope,
          batch_size: config[:batch_size] || 100
        )
      end

      # Define the sink for this data flow
      # @param model_class [Class] The ActiveRecord model to write to
      # @param config [Hash] Configuration options
      # @option config [Integer] :batch_size Batch size for writes
      def sink(model_class, config = {})
        self.sink_connector = ActiveDataFlow::Connector::Sink::ActiveRecordSink.new(
          model_class: model_class,
          batch_size: config[:batch_size] || 100
        )
      end

      # Define the runtime for this data flow
      # @param runtime_instance [ActiveDataFlow::Runtime::Base] Runtime instance
      def runtime(runtime_runner)
        self.runtime_runner = runtime_runner
      end

      # Register the data flow
      # @param name [String] Name of the data flow
      def register(name:)
        self.data_flow_instance = ActiveDataFlow::DataFlow.find_or_create(
          name: name,
          source: source_connector,
          sink: sink_connector,
          runtime: runtime_connector
        )
      end

      # Execute the data flow
      def execute
        raise "Data flow not registered. Call register(name: 'flow_name') first." unless data_flow_instance

        source_connector.each do |record|
          sink_connector.write(record)
        end
      end
    end
  end
end