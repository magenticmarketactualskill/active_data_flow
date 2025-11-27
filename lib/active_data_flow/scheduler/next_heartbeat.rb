# frozen_string_literal: true

module ActiveDataFlow
  module Scheduler
    # Handles heartbeat-based scheduling for ActiveDataFlow
    # 
    # This class is responsible for:
    # - Finding flows that are due to run based on their heartbeat schedule
    # - Executing due flows with proper error handling and logging
    # - Managing the lifecycle of data flow runs
    class NextHeartbeat
      def self.call
        new.call
      end

      def call
        Rails.logger.info("[ActiveDataFlow::Scheduler] Checking for due flows...")
        
        due_flows = find_due_flows
        return Rails.logger.info("[ActiveDataFlow::Scheduler] No flows due to run") if due_flows.empty?

        Rails.logger.info("[ActiveDataFlow::Scheduler] Found #{due_flows.count} flow(s) due to run")
        
        due_flows.find_each do |data_flow|
          execute_flow(data_flow)
        end
        
        Rails.logger.info("[ActiveDataFlow::Scheduler] Heartbeat cycle completed")
      end

      private

      # Find all flows that have pending runs due to execute
      def find_due_flows
        ActiveDataFlow::DataFlow.due_to_run
      end

      # Execute a single data flow
      def execute_flow(data_flow)
        run_record = data_flow.next_due_run
        return unless run_record

        Rails.logger.info("[ActiveDataFlow::Scheduler] Executing flow: #{data_flow.name} (run_id: #{run_record.id})")
        
        begin
          run_record.start!
          
          # Instantiate and execute the flow
          flow_instance = instantiate_flow(data_flow)
          flow_instance.run
          
          run_record.complete!
          Rails.logger.info("[ActiveDataFlow::Scheduler] Completed flow: #{data_flow.name} (run_id: #{run_record.id})")
        rescue StandardError => e
          run_record.fail!(e)
          Rails.logger.error("[ActiveDataFlow::Scheduler] Failed flow: #{data_flow.name} (run_id: #{run_record.id}): #{e.message}")
          Rails.logger.error(e.backtrace.join("\n"))
        end
      end

      # Instantiate a flow class from its data flow record
      def instantiate_flow(data_flow)
        flow_class_name = data_flow.name.classify
        
        unless Object.const_defined?(flow_class_name)
          raise "Flow class #{flow_class_name} not found for data flow: #{data_flow.name}"
        end
        
        flow_class = Object.const_get(flow_class_name)
        flow_class.new
      end

      # Class methods for specific flow types (extracted from example)
      module FlowHelpers
        # Find flows of a specific type that are due to run
        def self.due_flows_for(flow_name)
          ActiveDataFlow::DataFlow.due_to_run.where(name: flow_name)
        end

        # Run all due instances of a specific flow type
        def self.run_due_for(flow_class)
          flow_name = flow_class.name.underscore
          due_flows_for(flow_name).find_each do |data_flow|
            flow_instance = flow_class.new
            flow_instance.run_if_due
          end
        end
      end
    end
  end
end