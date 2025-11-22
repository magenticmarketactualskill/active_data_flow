# frozen_string_literal: true

require "rails/generators"

module ActiveDataFlow
  module Generators
    class DataFlowGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      desc "Generate a new data flow class"

      def create_data_flow_file
        template "data_flow.rb.tt", "app/data_flows/#{file_name}_flow.rb"
      end
    end
  end
end
