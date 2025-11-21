# frozen_string_literal: true

require "active_data_flow/version"
require "active_data_flow/engine"
require "active_data_flow/railtie" if defined?(Rails::Railtie)

# Load base classes
require "active_data_flow/connector/source"
require "active_data_flow/connector/sink"
require "active_data_flow/runtime/base"

require "active_data_flow/message"
require "active_data_flow/connector"
require "active_data_flow/runtime"