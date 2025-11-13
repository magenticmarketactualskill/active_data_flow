# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/cli'

module Submoduler
  class TestCLIIntegration < Minitest::Test
    def setup
      @tmpdir = Dir.mktmpdir
      @original_dir = Dir.pwd
      Dir.chdir(@tmpdir)
      # Create .git directory to simulate git repo
      FileUtils.mkdir_p('.git')
    end

    def teardown
      Dir.chdir(@original_dir)
      FileUtils.rm_rf(@tmpdir)
    end

    def test_cli_with_help_flag
      output = capture_io do
        exit_code = CLI.run(['--help'])
        assert_equal 0, exit_code
      end

      assert_match(/Submoduler - Git Submodule Configuration Tool/, output[0])
      assert_match(/Usage:/, output[0])
      assert_match(/Commands:/, output[0])
    end

    def test_cli_with_no_arguments
      output = capture_io do
        exit_code = CLI.run([])
        assert_equal 0, exit_code
      end

      assert_match(/Usage:/, output[0])
    end

    def test_cli_with_unknown_command
      output = capture_io do
        exit_code = CLI.run(['unknown'])
        assert_equal 2, exit_code
      end

      assert_match(/Unknown command/, output[0])
    end

    def test_cli_report_command
      # Create a simple .gitmodules
      File.write('.gitmodules', <<~GITMODULES)
        [submodule "test"]
        \tpath = test
        \turl = https://github.com/test/repo.git
      GITMODULES

      output = capture_io do
        exit_code = CLI.run(['report'])
        assert_equal 1, exit_code # Will fail because directory doesn't exist
      end

      assert_match(/Submodule Configuration Report/, output[0])
    end

    def test_cli_not_in_git_repo
      # Remove .git directory
      FileUtils.rm_rf('.git')

      output = capture_io do
        exit_code = CLI.run(['report'])
        assert_equal 2, exit_code
      end

      assert_match(/Not a git repository/, output[0])
    end
  end
end
