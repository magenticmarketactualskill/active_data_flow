# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/submoduler_ini_parser'
require 'submoduler/test_command'
require 'submoduler/report_command'

module Submoduler
  class TestDefaultsEndToEnd < Minitest::Test
    def setup
      @tmpdir = Dir.mktmpdir
    end

    def teardown
      FileUtils.rm_rf(@tmpdir)
    end

    def test_complete_workflow_with_defaults_and_overrides
      # Create parent .submoduler.ini with defaults
      parent_ini = File.join(@tmpdir, '.submoduler.ini')
      File.write(parent_ini, <<~INI)
        [default]
        require_test = true
      INI

      # Create first submodule that uses parent default
      create_submodule('module1', override_require_test: nil)

      # Create second submodule that overrides to false
      create_submodule('module2', override_require_test: false)

      # Parse and verify configuration
      parser = SubmodulerIniParser.new(@tmpdir)
      entries = parser.parse

      assert_equal 2, entries.length

      module1 = entries.find { |e| e.name == 'module1' }
      assert module1.require_test?
      assert_empty module1.config_overrides

      module2 = entries.find { |e| e.name == 'module2' }
      refute module2.require_test?
      assert_equal ['require_test'], module2.config_overrides
    end

    def test_report_command_shows_overrides
      # Create parent with defaults
      parent_ini = File.join(@tmpdir, '.submoduler.ini')
      File.write(parent_ini, <<~INI)
        [default]
        require_test = true
      INI

      # Create submodule with override
      create_submodule('test', override_require_test: false)

      # Run report command and capture output
      output = capture_io do
        command = ReportCommand.new(@tmpdir)
        command.execute
      end

      # Verify override is shown in output
      assert_match(/Configuration Overrides/, output[0])
      assert_match(/require_test/, output[0])
      assert_match(/test → false/, output[0])
    end

    def test_parser_handles_missing_parent_defaults
      # No parent .submoduler.ini file

      # Create submodule with its own defaults
      create_submodule('test', override_require_test: true)

      parser = SubmodulerIniParser.new(@tmpdir)
      entries = parser.parse

      assert_equal 1, entries.length
      entry = entries.first
      assert entry.require_test?
      assert_empty entry.config_overrides
    end

    private

    def create_submodule(name, override_require_test:)
      submodule_dir = File.join(@tmpdir, 'submodules', name)
      FileUtils.mkdir_p(submodule_dir)

      # Create child .submoduler.ini
      child_ini_content = "[parent]\nurl = https://github.com/parent/repo.git\n"
      if override_require_test != nil
        child_ini_content += "\n[default]\nrequire_test = #{override_require_test}\n"
      end
      File.write(File.join(submodule_dir, '.submoduler.ini'), child_ini_content)

      # Initialize git
      FileUtils.mkdir_p(File.join(submodule_dir, '.git'))
    end
  end
end
