# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/configuration_report_formatter'
require 'submoduler/submodule_entry'

module Submoduler
  class TestConfigurationReportFormatter < Minitest::Test
    def test_format_with_no_overrides
      entries = [
        SubmoduleEntry.new(
          name: 'test',
          path: 'test/path',
          url: 'https://github.com/test/repo.git',
          config: { 'require_test' => 'true' },
          config_overrides: []
        )
      ]
      
      parent_defaults = { 'require_test' => 'true' }
      formatter = ConfigurationReportFormatter.new(entries, parent_defaults)
      output = formatter.format

      assert_equal "", output
    end

    def test_format_with_single_override
      entries = [
        SubmoduleEntry.new(
          name: 'test',
          path: 'test/path',
          url: 'https://github.com/test/repo.git',
          config: { 'require_test' => 'false' },
          config_overrides: ['require_test']
        )
      ]
      
      parent_defaults = { 'require_test' => 'true' }
      formatter = ConfigurationReportFormatter.new(entries, parent_defaults)
      output = formatter.format

      assert_match(/Configuration Overrides/, output)
      assert_match(/require_test/, output)
      assert_match(/Parent default: true/, output)
      assert_match(/test → false/, output)
    end

    def test_format_with_multiple_overrides_same_key
      entries = [
        SubmoduleEntry.new(
          name: 'module1',
          path: 'module1/path',
          url: 'https://github.com/test/repo1.git',
          config: { 'require_test' => 'false' },
          config_overrides: ['require_test']
        ),
        SubmoduleEntry.new(
          name: 'module2',
          path: 'module2/path',
          url: 'https://github.com/test/repo2.git',
          config: { 'require_test' => 'false' },
          config_overrides: ['require_test']
        )
      ]
      
      parent_defaults = { 'require_test' => 'true' }
      formatter = ConfigurationReportFormatter.new(entries, parent_defaults)
      output = formatter.format

      assert_match(/Configuration Overrides/, output)
      assert_match(/require_test/, output)
      assert_match(/Parent default: true/, output)
      assert_match(/module1 → false/, output)
      assert_match(/module2 → false/, output)
    end

    def test_format_with_empty_parent_defaults
      entries = [
        SubmoduleEntry.new(
          name: 'test',
          path: 'test/path',
          url: 'https://github.com/test/repo.git',
          config: { 'require_test' => 'false' },
          config_overrides: ['require_test']
        )
      ]
      
      parent_defaults = {}
      formatter = ConfigurationReportFormatter.new(entries, parent_defaults)
      output = formatter.format

      assert_equal "", output
    end

    def test_format_with_empty_entries
      entries = []
      parent_defaults = { 'require_test' => 'true' }
      formatter = ConfigurationReportFormatter.new(entries, parent_defaults)
      output = formatter.format

      assert_equal "", output
    end
  end
end
