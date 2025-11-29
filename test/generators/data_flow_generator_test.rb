# frozen_string_literal: true

require 'test_helper'
require 'rails/generators/test_case'
require 'generators/active_data_flow/data_flow_generator'

module ActiveDataFlow
  module Generators
    class DataFlowGeneratorTest < Rails::Generators::TestCase
      tests ActiveDataFlow::Generators::DataFlowGenerator
      destination File.expand_path("../../tmp", __dir__)
      setup :prepare_destination

      test "generator creates data flow file with default options" do
        assert_generated_flow("product_sync") do |content|
          assert_includes_structure(content, "ProductSyncFlow", "product_sync_flow")
          assert_match(/model_class: ProductSync/, content)
        end
      end

      test "generator uses custom scope option" do
        assert_generated_flow("product_sync", "--scope=Product.active") do |content|
          assert_match(/scope: Product\.active/, content)
        end
      end

      test "generator uses custom batch_size option" do
        assert_generated_flow("product_sync", "--batch-size=50") do |content|
          assert_match(/batch_size: 50/, content)
        end
      end

      test "generator uses custom model_class option" do
        assert_generated_flow("product_sync", "--model-class=ProductExport") do |content|
          assert_match(/model_class: ProductExport/, content)
        end
      end

      test "generator includes all templates" do
        assert_generated_flow("product_sync") do |content|
          assert_includes_templates(content)
        end
      end

      test "generator handles scope_params array option" do
        assert_generated_flow("product_sync", "--scope-params=active", "published") do |content|
          assert_match(/scope_params: \["active", "published"\]/, content)
        end
      end

      test "generator creates file with correct naming convention" do
        assert_generated_flow("user_export") do |content|
          assert_includes_structure(content, "UserExportFlow", "user_export_flow")
        end
      end

      private

      def assert_generated_flow(name, *args)
        run_generator [name, *args]
        assert_file "app/data_flows/#{name}_flow.rb" do |content|
          yield content if block_given?
        end
      end

      def assert_includes_structure(content, class_name, flow_name)
        [
          /class #{class_name}/,
          /require 'active_data_flow'/,
          /def self\.register/,
          /def transform\(data\)/,
          /name: "#{flow_name}"/,
          /private/,
          /# TODO: Implement your transformation logic here/
        ].each { |pattern| assert_match(pattern, content) }
      end

      def assert_includes_templates(content)
        {
          source: [/ActiveDataFlow::Connector::Source::ActiveRecordSource\.new/, /scope:/, /scope_params:/, /batch_size:/],
          sink: [/ActiveDataFlow::Connector::Sink::ActiveRecordSink\.new/, /model_class:/],
          runtime: [/ActiveDataFlow::Runtime::Heartbeat\.new/]
        }.each_value { |patterns| patterns.each { |pattern| assert_match(pattern, content) } }
      end
    end
  end
end
