# frozen_string_literal: true

module ActiveDataFlow
  class DataFlowsController < ApplicationController
    def heartbeat_event
      Rails.logger.info "[ActiveDataFlow::DataFlowsController.heartbeat_event] called"
      # see submodules/active_data_flow-runtime-heartbeat/app/controllers/active_data_flow/runtime/heartbeat/data_flows_controller.rb
    end
  end
end
