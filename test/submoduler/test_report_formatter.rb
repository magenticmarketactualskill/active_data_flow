# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/report_formatter'
require 'submoduler/validation_result'

module Submoduler
  class TestReportFormatter < Minitest::Test
    def test_format_with_passed_results
      results = [
        ValidationResult.new(
          submodule_name: 'test/module',
          check_type: :path_exists,
          status: :pass,
          message: 'Directory exists'
        )
      ]

      formatter = ReportFormatter.new(results, submodule_count: 1)
      output = formatter.format

      assert_match(/Submodule Configuration Report/, output)
      assert_match(/Path Validation/, output)
      assert_match(/✓/, output)
      assert_match(/test\/module/, output)
      assert_match(/1 passed/, output)
      assert_match(/0 failed/, output)
    end

    def test_format_with_failed_results
      results = [
        ValidationResult.new(
          submodule_name: 'test/module',
          check_type: :path_exists,
          status: :fail,
          message: 'Directory not found'
        )
      ]

      formatter = ReportFormatter.new(results, submodule_count: 1)
      output = formatter.format

      assert_match(/✗/, output)
      assert_match(/test\/module/, output)
      assert_match(/Directory not found/, output)
      assert_match(/0 passed/, output)
      assert_match(/1 failed/, output)
    end

    def test_format_groups_by_check_type
      results = [
        ValidationResult.new(
          submodule_name: 'module1',
          check_type: :path_exists,
          status: :pass
        ),
        ValidationResult.new(
          submodule_name: 'module1',
          check_type: :initialization,
          status: :pass
        )
      ]

      formatter = ReportFormatter.new(results, submodule_count: 1)
      output = formatter.format

      assert_match(/Path Validation/, output)
      assert_match(/Initialization Check/, output)
    end

    def test_format_includes_header_with_timestamp
      results = []
      formatter = ReportFormatter.new(results, submodule_count: 0)
      output = formatter.format

      assert_match(/Submodule Configuration Report/, output)
      assert_match(/Generated:/, output)
      assert_match(/\d{4}-\d{2}-\d{2}/, output)
    end

    def test_format_includes_configuration_section
      results = []
      formatter = ReportFormatter.new(results, submodule_count: 3)
      output = formatter.format

      assert_match(/Submodule Configuration Check/, output)
      assert_match(/Found .gitmodules file/, output)
      assert_match(/Parsed 3 submodule entries/, output)
    end

    def test_format_summary_counts
      results = [
        ValidationResult.new(submodule_name: 'm1', check_type: :path_exists, status: :pass),
        ValidationResult.new(submodule_name: 'm2', check_type: :path_exists, status: :fail),
        ValidationResult.new(submodule_name: 'm3', check_type: :initialization, status: :pass)
      ]

      formatter = ReportFormatter.new(results, submodule_count: 3)
      output = formatter.format

      assert_match(/Summary:/, output)
      assert_match(/2 passed/, output)
      assert_match(/1 failed/, output)
    end
  end
end
