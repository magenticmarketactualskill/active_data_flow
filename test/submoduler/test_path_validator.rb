# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/path_validator'
require 'submoduler/submodule_entry'

module Submoduler
  class TestPathValidator < Minitest::Test
    def setup
      @tmpdir = Dir.mktmpdir
    end

    def teardown
      FileUtils.rm_rf(@tmpdir)
    end

    def test_validate_existing_path
      # Create a directory
      submodule_path = 'test/module'
      FileUtils.mkdir_p(File.join(@tmpdir, submodule_path))

      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: submodule_path,
        url: 'https://github.com/test/repo.git'
      )

      validator = PathValidator.new(@tmpdir, [entry])
      results = validator.validate

      path_result = results.find { |r| r.check_type == :path_exists }
      assert path_result.passed?
    end

    def test_validate_missing_path
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'nonexistent/path',
        url: 'https://github.com/test/repo.git'
      )

      validator = PathValidator.new(@tmpdir, [entry])
      results = validator.validate

      path_result = results.find { |r| r.check_type == :path_exists }
      assert path_result.failed?
      assert_match(/Directory not found/, path_result.message)
    end

    def test_validate_relative_path
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'relative/path',
        url: 'https://github.com/test/repo.git'
      )

      validator = PathValidator.new(@tmpdir, [entry])
      results = validator.validate

      # Should not have a relative path failure
      relative_result = results.find { |r| r.check_type == :path_relative }
      assert_nil relative_result
    end

    def test_validate_absolute_path
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: '/absolute/path',
        url: 'https://github.com/test/repo.git'
      )

      validator = PathValidator.new(@tmpdir, [entry])
      results = validator.validate

      relative_result = results.find { |r| r.check_type == :path_relative }
      assert relative_result.failed?
      assert_match(/not relative/, relative_result.message)
    end

    def test_validate_multiple_entries
      # Create one valid path
      FileUtils.mkdir_p(File.join(@tmpdir, 'valid/path'))

      entries = [
        SubmoduleEntry.new(name: 'valid', path: 'valid/path', url: 'https://github.com/test/repo1.git'),
        SubmoduleEntry.new(name: 'invalid', path: 'invalid/path', url: 'https://github.com/test/repo2.git')
      ]

      validator = PathValidator.new(@tmpdir, entries)
      results = validator.validate

      path_results = results.select { |r| r.check_type == :path_exists }
      assert_equal 2, path_results.length
      assert_equal 1, path_results.count(&:passed?)
      assert_equal 1, path_results.count(&:failed?)
    end
  end
end
