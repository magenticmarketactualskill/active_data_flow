# frozen_string_literal: true

require 'active_record'
require 'active_support'
require 'active_data_flow'

require_relative 'active_data_flow/sink/active_record'
require_relative 'active_data_flow/source/active_record'

module ActiveDataFlow
  module ActiveRecord
    VERSION = '0.1.0'
  end
end
