# frozen_string_literal: true
# typed: false

require 'sorbet-runtime'
require_relative '../base_data_flow_run'

module ActiveDataFlow
  module Redcord
    class DataFlowRun < T::Struct
      include ::Redcord::Base
      include ActiveDataFlow::BaseDataFlowRun

      # Schema definition using Redcord's attribute method
      # Note: index: true automatically creates appropriate index type based on data type
      # Type safety is enforced by Sorbet at runtime
      attribute :data_flow_id, String, index: true
      attribute :status, String, index: true
      attribute :run_after, Integer, index: true    # Unix timestamp (range index)
      attribute :started_at, T.nilable(Integer)
      attribute :ended_at, T.nilable(Integer)
      attribute :error_message, T.nilable(String)
      attribute :first_id, T.nilable(String)
      attribute :last_id, T.nilable(String)

      # Tell Rails how to generate routes for this model
      def self.model_name
        @_model_name ||= ActiveModel::Name.new(self, ActiveDataFlow, "data_flow_run")
      end

      def self.create_pending_for_data_flow(data_flow)
        interval = data_flow.interval_seconds
        next_run = Time.current.to_i + interval

        create!(
          data_flow_id: data_flow.id,
          status: 'pending',
          run_after: next_run,
          created_at: Time.current.to_i,
          updated_at: Time.current.to_i
        )
      end

      # Association helper
      def data_flow
        ActiveDataFlow::Redcord::DataFlow.find(data_flow_id)
      end

      # Scopes (implemented as class methods)
      def self.due_to_run
        where(status: 'pending').select { |run| run.run_after <= Time.current.to_i }
      end

      def self.pending
        where(status: 'pending')
      end

      def self.in_progress
        where(status: 'in_progress')
      end

      def self.success
        where(status: 'success')
      end

      def self.completed
        all.select { |run| run.completed? }
      end

      def self.due
        all.select { |run| run.run_after <= Time.current.to_i }
      end

      def self.overdue
        pending.select { |run| run.run_after <= 1.hour.ago.to_i }
      end

      # Redcord-specific implementations
      
      protected
      
      def run_after_time
        # Convert Unix timestamp to Time object for comparison
        Time.at(run_after)
      end
    end
  end
end
