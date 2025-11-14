# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/submodule_entry'

module Submoduler
  class TestSubmoduleEntry < Minitest::Test
    def test_require_test_with_true_value
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/path',
        url: 'https://github.com/test/repo.git',
        config: { 'require_test' => 'true' }
      )

      assert entry.require_test?
    end

    def test_require_test_with_false_value
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/path',
        url: 'https://github.com/test/repo.git',
        config: { 'require_test' => 'false' }
      )

      refute entry.require_test?
    end

    def test_require_test_with_missing_value
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/path',
        url: 'https://github.com/test/repo.git',
        config: {}
      )

      refute entry.require_test?
    end

    def test_require_test_with_uppercase_true
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/path',
        url: 'https://github.com/test/repo.git',
        config: { 'require_test' => 'TRUE' }
      )

      assert entry.require_test?
    end

    def test_require_test_with_mixed_case
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/path',
        url: 'https://github.com/test/repo.git',
        config: { 'require_test' => 'TrUe' }
      )

      assert entry.require_test?
    end

    def test_require_test_with_invalid_value
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/path',
        url: 'https://github.com/test/repo.git',
        config: { 'require_test' => 'maybe' }
      )

      refute entry.require_test?
    end

    def test_config_overrides_tracking
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/path',
        url: 'https://github.com/test/repo.git',
        config: { 'require_test' => 'true' },
        config_overrides: ['require_test']
      )

      assert_equal ['require_test'], entry.config_overrides
    end

    def test_empty_config_overrides
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/path',
        url: 'https://github.com/test/repo.git',
        config: { 'require_test' => 'true' },
        config_overrides: []
      )

      assert_empty entry.config_overrides
    end

    def test_default_config_when_not_provided
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/path',
        url: 'https://github.com/test/repo.git'
      )

      assert_equal({}, entry.config)
      assert_equal([], entry.config_overrides)
    end
  end
end
