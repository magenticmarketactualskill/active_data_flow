# frozen_string_literal: true
# typed: false

require 'sorbet-runtime'
require_relative '../base_data_flow'

module ActiveDataFlow
  module Redcord
    class DataFlow < T::Struct
      include ::Redcord::Base
      include ActiveDataFlow::BaseDataFlow

      # Schema definition using Redcord's attribute method
      # Note: index: true automatically creates appropriate index type based on data type
      # Type safety is enforced by Sorbet at runtime
      attribute :name, String, index: true
      attribute :source, String  # JSON serialized
      attribute :sink, String    # JSON serialized
      attribute :runtime, T.nilable(String) # JSON serialized
      attribute :status, String, index: true
      attribute :next_source_id, T.nilable(String)
      attribute :last_run_at, T.nilable(Integer)  # Unix timestamp (range index)
      attribute :last_error, T.nilable(String)

      # Tell Rails how to generate routes for this model
      def self.model_name
        @_model_name ||= ActiveModel::Name.new(self, ActiveDataFlow, "data_flow")
      end

      def self.find_or_create(name:, source:, sink:, runtime:)
        flow = find_by(name: name) || new
        flow.name = name
        flow.source = source.as_json.to_json
        flow.sink = sink.as_json.to_json
        flow.runtime = runtime&.as_json&.to_json
        flow.status = 'active'
        flow.created_at ||= Time.current.to_i
        flow.updated_at = Time.current.to_i
        flow.save!
        flow
      end

      # Association helpers (Redcord doesn't have built-in associations)
      def data_flow_runs
        ActiveDataFlow::Redcord::DataFlowRun.where(data_flow_id: id)
      end

      # Scopes (implemented as class methods)
      def self.active
        where(status: 'active')
      end

      def self.inactive
        where(status: 'inactive')
      end

      def self.due_to_run
        # Find flows with pending runs that are due
        active_flows = active.to_a
        active_flows.select do |flow|
          flow.data_flow_runs.any? { |run| run.pending? && run.run_after <= Time.current.to_i }
        end
      end



      # Get the next pending run that's due
      def next_due_run
        data_flow_runs
          .select { |r| r.pending? && r.run_after <= Time.current.to_i }
          .min_by(&:run_after)
      end

      # Schedule the next run based on interval
      def schedule_next_run(from_time = Time.current)
        return unless enabled?

        next_run_time = from_time.to_i + interval_seconds
        ActiveDataFlow::Redcord::DataFlowRun.create!(
          data_flow_id: id,
          run_after: next_run_time,
          status: 'pending',
          created_at: Time.current.to_i,
          updated_at: Time.current.to_i
        )
      end

      # Mark a run as started and schedule the next one
      def mark_run_started!(run)
        run.status = 'in_progress'
        run.started_at = Time.current.to_i
        run.updated_at = Time.current.to_i
        run.save!

        self.last_run_at = Time.current.to_i
        self.last_error = nil
        self.updated_at = Time.current.to_i
        save!

        schedule_next_run
      end

      # Mark a run as completed successfully
      def mark_run_completed!(run)
        run.status = 'success'
        run.ended_at = Time.current.to_i
        run.updated_at = Time.current.to_i
        run.save!
      end

      # Mark a run as failed
      def mark_run_failed!(run, error)
        run.status = 'failed'
        run.ended_at = Time.current.to_i
        run.error_message = error.to_s
        run.updated_at = Time.current.to_i
        run.save!

        self.last_error = error.to_s
        self.updated_at = Time.current.to_i
        save!
      end

      # Redcord-specific implementation methods
      
      protected
      
      def current_in_progress_run
        data_flow_runs.find { |r| r.in_progress? }
      end
      
      def update_next_source_id(last_id)
        self.next_source_id = last_id
        save!
      end
      
      def update_run_cursors(run, first_id, last_id)
        run.first_id = first_id
        run.last_id = last_id
        run.save!
      end

      private

      # Helper methods for JSON parsing
      def parsed_source
        source ? JSON.parse(source) : nil
      rescue JSON::ParserError
        nil
      end

      def parsed_sink
        sink ? JSON.parse(sink) : nil
      rescue JSON::ParserError
        nil
      end

      def parsed_runtime
        runtime ? JSON.parse(runtime) : nil
      rescue JSON::ParserError
        nil
      end
    end
  end
end
