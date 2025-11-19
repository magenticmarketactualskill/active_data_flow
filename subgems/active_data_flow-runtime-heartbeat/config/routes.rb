# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :active_data_flow do
    post "/data_flows/heartbeat", to: "runtime/heartbeat/data_flows#heartbeat", as: :heartbeat
  end
end
