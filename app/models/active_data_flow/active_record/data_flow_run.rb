# frozen_string_literal: true

require_relative '../base_data_flow_run'

module ActiveDataFlow
  module ActiveRecord
    class DataFlowRun < ::ActiveRecord::Base
      include ActiveDataFlow::BaseDataFlowRun
      
      self.table_name = "active_data_flow_data_flow_runs"

      # Associations
      belongs_to :data_flow, class_name: "ActiveDataFlow::ActiveRecord::DataFlow"

      # Validations
      validates :status, inclusion: { in: %w[pending in_progress success failed cancelled] }
      validates :run_after, presence: true

      # Scopes
      # Scope to find flows that have pending runs due to execute
      scope :due_to_run, -> {
        where(status: 'pending', run_after: ..Time.current)
          .joins(:data_flow)
      }
      scope :pending, -> { where(status: 'pending') }
      scope :in_progress, -> { where(status: 'in_progress') }
      scope :success, -> { where(status: 'success') }
      scope :completed, -> { where(status: ['success', 'failed']) }
      scope :due, -> { where(run_after: ..Time.current) }
      scope :overdue, -> { pending.where(run_after: ..1.hour.ago) }

      def self.create_pending_for_data_flow(data_flow)
        interval = data_flow.interval_seconds
        next_run = Time.current + interval
        
        data_flow.data_flow_runs.create!(
          status: 'pending',
          run_after: next_run
        )
      end

      # Tell Rails how to generate routes for this model
      def self.model_name
        @_model_name ||= ActiveModel::Name.new(self, ActiveDataFlow, "data_flow_run")
      end

      # ActiveRecord-specific implementations are inherited from BaseDataFlowRun
    end
  end
end
