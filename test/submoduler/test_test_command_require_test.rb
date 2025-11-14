# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/test_command'
require 'submoduler/submodule_entry'

module Submoduler
  class TestTestCommandRequireTest < Minitest::Test
    def test_determine_exit_code_with_required_test_passing
      command = TestCommand.new('/tmp')
      
      entries = [
        SubmoduleEntry.new(
          name: 'test',
          path: 'test/path',
          url: 'https://github.com/test/repo.git',
          config: { 'require_test' => 'true' }
        )
      ]
      
      test_results = [
        { name: 'test', status: :passed }
      ]
      
      exit_code = command.send(:determine_exit_code, test_results, entries)
      assert_equal 0, exit_code
    end

    def test_determine_exit_code_with_required_test_failing
      command = TestCommand.new('/tmp')
      
      entries = [
        SubmoduleEntry.new(
          name: 'test',
          path: 'test/path',
          url: 'https://github.com/test/repo.git',
          config: { 'require_test' => 'true' }
        )
      ]
      
      test_results = [
        { name: 'test', status: :failed }
      ]
      
      exit_code = command.send(:determine_exit_code, test_results, entries)
      assert_equal 1, exit_code
    end

    def test_determine_exit_code_with_optional_test_failing
      command = TestCommand.new('/tmp')
      
      entries = [
        SubmoduleEntry.new(
          name: 'test',
          path: 'test/path',
          url: 'https://github.com/test/repo.git',
          config: { 'require_test' => 'false' }
        )
      ]
      
      test_results = [
        { name: 'test', status: :failed }
      ]
      
      exit_code = command.send(:determine_exit_code, test_results, entries)
      assert_equal 0, exit_code
    end

    def test_determine_exit_code_with_required_test_error
      command = TestCommand.new('/tmp')
      
      entries = [
        SubmoduleEntry.new(
          name: 'test',
          path: 'test/path',
          url: 'https://github.com/test/repo.git',
          config: { 'require_test' => 'true' }
        )
      ]
      
      test_results = [
        { name: 'test', status: :error }
      ]
      
      exit_code = command.send(:determine_exit_code, test_results, entries)
      assert_equal 1, exit_code
    end

    def test_determine_exit_code_with_mixed_results
      command = TestCommand.new('/tmp')
      
      entries = [
        SubmoduleEntry.new(
          name: 'optional',
          path: 'optional/path',
          url: 'https://github.com/test/repo1.git',
          config: { 'require_test' => 'false' }
        ),
        SubmoduleEntry.new(
          name: 'required',
          path: 'required/path',
          url: 'https://github.com/test/repo2.git',
          config: { 'require_test' => 'true' }
        )
      ]
      
      test_results = [
        { name: 'optional', status: :failed },
        { name: 'required', status: :passed }
      ]
      
      exit_code = command.send(:determine_exit_code, test_results, entries)
      assert_equal 0, exit_code
    end

    def test_determine_exit_code_with_mixed_results_required_failing
      command = TestCommand.new('/tmp')
      
      entries = [
        SubmoduleEntry.new(
          name: 'optional',
          path: 'optional/path',
          url: 'https://github.com/test/repo1.git',
          config: { 'require_test' => 'false' }
        ),
        SubmoduleEntry.new(
          name: 'required',
          path: 'required/path',
          url: 'https://github.com/test/repo2.git',
          config: { 'require_test' => 'true' }
        )
      ]
      
      test_results = [
        { name: 'optional', status: :passed },
        { name: 'required', status: :failed }
      ]
      
      exit_code = command.send(:determine_exit_code, test_results, entries)
      assert_equal 1, exit_code
    end

    def test_determine_exit_code_with_no_require_test_config
      command = TestCommand.new('/tmp')
      
      entries = [
        SubmoduleEntry.new(
          name: 'test',
          path: 'test/path',
          url: 'https://github.com/test/repo.git',
          config: {}
        )
      ]
      
      test_results = [
        { name: 'test', status: :failed }
      ]
      
      # Without require_test, tests are optional, so should return 0
      exit_code = command.send(:determine_exit_code, test_results, entries)
      assert_equal 0, exit_code
    end
  end
end
