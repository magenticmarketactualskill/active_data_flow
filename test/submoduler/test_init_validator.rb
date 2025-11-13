# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/init_validator'
require 'submoduler/submodule_entry'

module Submoduler
  class TestInitValidator < Minitest::Test
    def setup
      @tmpdir = Dir.mktmpdir
    end

    def teardown
      FileUtils.rm_rf(@tmpdir)
    end

    def test_validate_initialized_submodule
      # Create directory with .git file
      submodule_path = File.join(@tmpdir, 'test/module')
      FileUtils.mkdir_p(submodule_path)
      FileUtils.touch(File.join(submodule_path, '.git'))

      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/module',
        url: 'https://github.com/test/repo.git'
      )

      validator = InitValidator.new(@tmpdir, [entry])
      results = validator.validate

      assert_equal 1, results.length
      assert results[0].passed?
      assert_match(/initialized/, results[0].message)
    end

    def test_validate_uninitialized_submodule
      # Create directory without .git
      submodule_path = File.join(@tmpdir, 'test/module')
      FileUtils.mkdir_p(submodule_path)
      FileUtils.touch(File.join(submodule_path, 'some_file.txt'))

      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/module',
        url: 'https://github.com/test/repo.git'
      )

      validator = InitValidator.new(@tmpdir, [entry])
      results = validator.validate

      assert_equal 1, results.length
      assert results[0].failed?
      assert_match(/not initialized/, results[0].message)
    end

    def test_validate_empty_directory
      # Create empty directory
      submodule_path = File.join(@tmpdir, 'test/module')
      FileUtils.mkdir_p(submodule_path)

      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/module',
        url: 'https://github.com/test/repo.git'
      )

      validator = InitValidator.new(@tmpdir, [entry])
      results = validator.validate

      assert_equal 1, results.length
      assert results[0].failed?
      assert_match(/not checked out/, results[0].message)
    end

    def test_validate_missing_directory
      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'nonexistent/path',
        url: 'https://github.com/test/repo.git'
      )

      validator = InitValidator.new(@tmpdir, [entry])
      results = validator.validate

      assert_equal 1, results.length
      assert results[0].failed?
      assert_match(/does not exist/, results[0].message)
    end

    def test_validate_with_git_directory
      # Create directory with .git directory (not just file)
      submodule_path = File.join(@tmpdir, 'test/module')
      FileUtils.mkdir_p(File.join(submodule_path, '.git'))

      entry = SubmoduleEntry.new(
        name: 'test/module',
        path: 'test/module',
        url: 'https://github.com/test/repo.git'
      )

      validator = InitValidator.new(@tmpdir, [entry])
      results = validator.validate

      assert_equal 1, results.length
      assert results[0].passed?
    end
  end
end
