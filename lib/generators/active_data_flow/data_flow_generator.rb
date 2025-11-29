# frozen_string_literal: true

require "rails/generators"

module ActiveDataFlow
  module Generators
    class DataFlowGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      desc "Generate a new data flow class"

      class_option :scope, type: :string, default: "Model.all", desc: "ActiveRecord scope for the source"
      class_option :scope_params, type: :array, default: [], desc: "Parameters for the scope"
      class_option :batch_size, type: :numeric, default: 100, desc: "Batch size for processing"
      class_option :model_class, type: :string, desc: "Model class for the sink"

      def create_data_flow_file
        template "data_flow.rb.tt", "app/data_flows/#{file_name}_flow.rb"
      end

      private

      def scope
        options[:scope]
      end

      def scope_params
        options[:scope_params].inspect
      end

      def batch_size
        options[:batch_size]
      end

      def model_class
        options[:model_class] || class_name
      end

      def render_template(template_name)
        template_path = File.join(self.class.source_root, template_name + ".tt")
        template_content = File.read(template_path)
        ERB.new(template_content, trim_mode: '-').result(binding)
      end
    end
  end
end
