# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/report_command'

module Submoduler
  class TestReportCommandIntegration < Minitest::Test
    def setup
      @tmpdir = Dir.mktmpdir
      # Create .git directory to simulate git repo
      FileUtils.mkdir_p(File.join(@tmpdir, '.git'))
    end

    def teardown
      FileUtils.rm_rf(@tmpdir)
    end

    def test_report_with_no_gitmodules
      command = ReportCommand.new(@tmpdir)
      
      output = capture_io do
        exit_code = command.execute
        assert_equal 0, exit_code
      end

      assert_match(/No .gitmodules file found/, output[0])
    end

    def test_report_with_valid_submodules
      # Create .gitmodules
      create_gitmodules([
        { name: 'module1', path: 'path1', url: 'https://github.com/test/repo1.git' }
      ])

      # Create the directory with .git
      module_path = File.join(@tmpdir, 'path1')
      FileUtils.mkdir_p(module_path)
      FileUtils.touch(File.join(module_path, '.git'))

      command = ReportCommand.new(@tmpdir)
      
      output = capture_io do
        exit_code = command.execute
        assert_equal 0, exit_code
      end

      assert_match(/Submodule Configuration Report/, output[0])
      assert_match(/Parsed 1 submodule/, output[0])
      assert_match(/2 passed/, output[0])
      assert_match(/0 failed/, output[0])
    end

    def test_report_with_invalid_submodules
      # Create .gitmodules with non-existent path
      create_gitmodules([
        { name: 'module1', path: 'nonexistent', url: 'https://github.com/test/repo1.git' }
      ])

      command = ReportCommand.new(@tmpdir)
      
      output = capture_io do
        exit_code = command.execute
        assert_equal 1, exit_code
      end

      assert_match(/Directory not found/, output[0])
      assert_match(/0 passed/, output[0])
      assert_match(/2 failed/, output[0])
    end

    def test_report_with_mixed_valid_invalid
      # Create .gitmodules with two modules
      create_gitmodules([
        { name: 'valid', path: 'valid_path', url: 'https://github.com/test/repo1.git' },
        { name: 'invalid', path: 'invalid_path', url: 'https://github.com/test/repo2.git' }
      ])

      # Create only the valid one
      module_path = File.join(@tmpdir, 'valid_path')
      FileUtils.mkdir_p(module_path)
      FileUtils.touch(File.join(module_path, '.git'))

      command = ReportCommand.new(@tmpdir)
      
      output = capture_io do
        exit_code = command.execute
        assert_equal 1, exit_code
      end

      assert_match(/Parsed 2 submodule/, output[0])
      assert_match(/2 passed/, output[0])
      assert_match(/2 failed/, output[0])
    end

    def test_report_with_uninitialized_submodule
      # Create .gitmodules
      create_gitmodules([
        { name: 'module1', path: 'path1', url: 'https://github.com/test/repo1.git' }
      ])

      # Create directory but without .git
      module_path = File.join(@tmpdir, 'path1')
      FileUtils.mkdir_p(module_path)
      FileUtils.touch(File.join(module_path, 'some_file.txt'))

      command = ReportCommand.new(@tmpdir)
      
      output = capture_io do
        exit_code = command.execute
        assert_equal 1, exit_code
      end

      assert_match(/not initialized/, output[0])
      assert_match(/1 passed/, output[0])
      assert_match(/1 failed/, output[0])
    end

    def test_report_with_empty_directory
      # Create .gitmodules
      create_gitmodules([
        { name: 'module1', path: 'path1', url: 'https://github.com/test/repo1.git' }
      ])

      # Create empty directory
      FileUtils.mkdir_p(File.join(@tmpdir, 'path1'))

      command = ReportCommand.new(@tmpdir)
      
      output = capture_io do
        exit_code = command.execute
        assert_equal 1, exit_code
      end

      assert_match(/not checked out/, output[0])
    end

    def test_report_with_malformed_gitmodules
      # Create malformed .gitmodules (missing url)
      content = <<~GITMODULES
        [submodule "test"]
        \tpath = test/path
      GITMODULES
      
      File.write(File.join(@tmpdir, '.gitmodules'), content)

      command = ReportCommand.new(@tmpdir)
      
      output = capture_io do
        exit_code = command.execute
        assert_equal 1, exit_code
      end

      assert_match(/Error parsing .gitmodules/, output[0])
      assert_match(/missing path or url/, output[0])
    end

    private

    def create_gitmodules(modules)
      content = modules.map do |mod|
        <<~MODULE
          [submodule "#{mod[:name]}"]
          \tpath = #{mod[:path]}
          \turl = #{mod[:url]}
        MODULE
      end.join("\n")

      File.write(File.join(@tmpdir, '.gitmodules'), content)
    end
  end
end
