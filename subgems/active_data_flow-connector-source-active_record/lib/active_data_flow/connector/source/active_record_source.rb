# frozen_string_literal: true

module ActiveDataFlow
  module Connector
    module Source
      class ActiveRecordSource < ::ActiveDataFlow::Connector::Source::Base
        attr_reader :model_class, :scope

        def initialize(model_class:,scope:)
          super()
          @model_class = model_class
          @scope = scope
        end

        def each(&block)
          iterate_records(&block)
        end

        def close
          # Release any resources if needed
        end

        private

        def build_query
          query = resolve_model.all
          query = query.where(@config[:where]) if @config[:where]
          query = query.order(@config[:order]) if @config[:order]
          query = query.limit(@config[:limit]) if @config[:limit]
          query = query.select(@config[:select]) if @config[:select]
          query = query.includes(@config[:includes]) if @config[:includes]
          query = query.readonly if @config.fetch(:readonly, true)
          query
        end

        def iterate_records(&block)
          if @config[:batch_size]
            build_query.find_each(batch_size: @config[:batch_size], &block)
          else
            build_query.each(&block)
          end
        end
      end
    end
  end
end
