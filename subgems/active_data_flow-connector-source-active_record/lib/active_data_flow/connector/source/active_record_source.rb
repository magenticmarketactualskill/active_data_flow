# frozen_string_literal: true

module ActiveDataFlow
  module Connector
    module Source
      class ActiveRecordSource < ::ActiveDataFlow::Connector::Source::Base
        attr_reader :model_class, :scope_name, :scope_params, :batch_size

        # Initialize with either a scope or model_class + scope_name
        # 
        # Examples:
        #   # Using a scope directly (not serializable)
        #   new(scope: User.where(active: true))
        #   
        #   # Using model class and scope name (serializable)
        #   new(model_class: User, scope_name: :active)
        #   new(model_class: User, scope_name: :created_after, scope_params: [1.week.ago])
        def initialize(scope: nil, scope_params: [], batch_size: nil)

          # extract model for serialization
          @model_class = scope.model
          @scope_name = scope.name
          @scope_params = []
          
          @batch_size ||= 5
          
          # Store serializable representation
          super(
            model_class: @model_class.name,
            scope_name: @scope_name,
            scope_params: @scope_params,
            batch_size: batch_size
          )
        end

        def each(&block)
          scope.find_each(batch_size: batch_size, &block)
        end

        def close
          # Release any resources if needed
        end
        
        private
        
        attr_reader :scope
        
        def build_scope
          model_class.public_send(scope_name, *scope_params)
        end
        
        # Override deserialization to reconstruct scope
        def self.from_json(data)
          model_class = Object.const_get(data["model_class"])
          
          new(
            model_class: model_class,
            scope_name: data["scope_name"],
            scope_params: data["scope_params"],
            batch_size: data["batch_size"]
          )
        end
      end
    end
  end
end
