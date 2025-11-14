# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/submoduler_ini_parser'

module Submoduler
  class TestSubmodulerIniParserDefaults < Minitest::Test
    def setup
      @tmpdir = Dir.mktmpdir
    end

    def teardown
      FileUtils.rm_rf(@tmpdir)
    end

    def test_parse_parent_defaults_with_valid_section
      parent_ini = File.join(@tmpdir, '.submoduler.ini')
      File.write(parent_ini, <<~INI)
        [default]
        require_test = true
      INI

      parser = SubmodulerIniParser.new(@tmpdir)
      defaults = parser.parse_parent_defaults

      assert_equal({ 'require_test' => 'true' }, defaults)
    end

    def test_parse_parent_defaults_with_missing_file
      parser = SubmodulerIniParser.new(@tmpdir)
      defaults = parser.parse_parent_defaults

      assert_equal({}, defaults)
    end

    def test_parse_parent_defaults_with_no_default_section
      parent_ini = File.join(@tmpdir, '.submoduler.ini')
      File.write(parent_ini, <<~INI)
        [submodule "test"]
        path = test/path
        url = https://github.com/test/repo.git
      INI

      parser = SubmodulerIniParser.new(@tmpdir)
      defaults = parser.parse_parent_defaults

      assert_equal({}, defaults)
    end

    def test_parse_parent_defaults_with_multiple_keys
      parent_ini = File.join(@tmpdir, '.submoduler.ini')
      File.write(parent_ini, <<~INI)
        [default]
        require_test = true
        auto_update = false
      INI

      parser = SubmodulerIniParser.new(@tmpdir)
      defaults = parser.parse_parent_defaults

      assert_equal({ 'require_test' => 'true', 'auto_update' => 'false' }, defaults)
    end

    def test_merge_configurations_with_no_overrides
      parser = SubmodulerIniParser.new(@tmpdir)
      parent_defaults = { 'require_test' => 'true' }
      child_defaults = {}

      result = parser.merge_configurations(parent_defaults, child_defaults)

      assert_equal({ 'require_test' => 'true' }, result[:config])
      assert_empty result[:overrides]
    end

    def test_merge_configurations_with_override
      parser = SubmodulerIniParser.new(@tmpdir)
      parent_defaults = { 'require_test' => 'true' }
      child_defaults = { 'require_test' => 'false' }

      result = parser.merge_configurations(parent_defaults, child_defaults)

      assert_equal({ 'require_test' => 'false' }, result[:config])
      assert_equal(['require_test'], result[:overrides])
    end

    def test_merge_configurations_with_new_key
      parser = SubmodulerIniParser.new(@tmpdir)
      parent_defaults = { 'require_test' => 'true' }
      child_defaults = { 'auto_update' => 'false' }

      result = parser.merge_configurations(parent_defaults, child_defaults)

      assert_equal({ 'require_test' => 'true', 'auto_update' => 'false' }, result[:config])
      assert_empty result[:overrides]
    end

    def test_merge_configurations_with_same_value
      parser = SubmodulerIniParser.new(@tmpdir)
      parent_defaults = { 'require_test' => 'true' }
      child_defaults = { 'require_test' => 'true' }

      result = parser.merge_configurations(parent_defaults, child_defaults)

      assert_equal({ 'require_test' => 'true' }, result[:config])
      assert_empty result[:overrides]
    end

    def test_parse_with_parent_defaults_and_child_override
      # Create parent .submoduler.ini with defaults
      parent_ini = File.join(@tmpdir, '.submoduler.ini')
      File.write(parent_ini, <<~INI)
        [default]
        require_test = true
      INI

      # Create submodule directory and child .submoduler.ini
      submodule_dir = File.join(@tmpdir, 'submodules', 'test')
      FileUtils.mkdir_p(submodule_dir)
      
      child_ini = File.join(submodule_dir, '.submoduler.ini')
      File.write(child_ini, <<~INI)
        [parent]
        url = https://github.com/parent/repo.git

        [default]
        require_test = false
      INI

      # Initialize git in submodule
      FileUtils.mkdir_p(File.join(submodule_dir, '.git'))

      parser = SubmodulerIniParser.new(@tmpdir)
      entries = parser.parse

      assert_equal 1, entries.length
      entry = entries.first
      assert_equal({ 'require_test' => 'false' }, entry.config)
      assert_equal(['require_test'], entry.config_overrides)
    end

    def test_parse_with_parent_defaults_no_child_override
      # Create parent .submoduler.ini with defaults
      parent_ini = File.join(@tmpdir, '.submoduler.ini')
      File.write(parent_ini, <<~INI)
        [default]
        require_test = true
      INI

      # Create submodule directory and child .submoduler.ini without defaults
      submodule_dir = File.join(@tmpdir, 'submodules', 'test')
      FileUtils.mkdir_p(submodule_dir)
      
      child_ini = File.join(submodule_dir, '.submoduler.ini')
      File.write(child_ini, <<~INI)
        [parent]
        url = https://github.com/parent/repo.git
      INI

      # Initialize git in submodule
      FileUtils.mkdir_p(File.join(submodule_dir, '.git'))

      parser = SubmodulerIniParser.new(@tmpdir)
      entries = parser.parse

      assert_equal 1, entries.length
      entry = entries.first
      assert_equal({ 'require_test' => 'true' }, entry.config)
      assert_empty entry.config_overrides
    end
  end
end
