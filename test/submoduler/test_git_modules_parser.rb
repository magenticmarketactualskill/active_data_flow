# frozen_string_literal: true

require_relative '../test_helper'
require 'submoduler/git_modules_parser'

module Submoduler
  class TestGitModulesParser < Minitest::Test
    def setup
      @tmpdir = Dir.mktmpdir
    end

    def teardown
      FileUtils.rm_rf(@tmpdir)
    end

    def test_exists_returns_true_when_gitmodules_exists
      create_gitmodules_file("")
      parser = GitModulesParser.new(@tmpdir)
      assert parser.exists?
    end

    def test_exists_returns_false_when_gitmodules_missing
      parser = GitModulesParser.new(@tmpdir)
      refute parser.exists?
    end

    def test_parse_valid_gitmodules
      content = <<~GITMODULES
        [submodule "test/module"]
        \tpath = test/module
        \turl = https://github.com/test/repo.git
      GITMODULES
      
      create_gitmodules_file(content)
      parser = GitModulesParser.new(@tmpdir)
      entries = parser.parse

      assert_equal 1, entries.length
      assert_equal "test/module", entries[0].name
      assert_equal "test/module", entries[0].path
      assert_equal "https://github.com/test/repo.git", entries[0].url
    end

    def test_parse_multiple_submodules
      content = <<~GITMODULES
        [submodule "module1"]
        \tpath = path1
        \turl = https://github.com/test/repo1.git
        [submodule "module2"]
        \tpath = path2
        \turl = https://github.com/test/repo2.git
      GITMODULES
      
      create_gitmodules_file(content)
      parser = GitModulesParser.new(@tmpdir)
      entries = parser.parse

      assert_equal 2, entries.length
      assert_equal "module1", entries[0].name
      assert_equal "module2", entries[1].name
    end

    def test_parse_raises_error_when_missing_path
      content = <<~GITMODULES
        [submodule "test/module"]
        \turl = https://github.com/test/repo.git
      GITMODULES
      
      create_gitmodules_file(content)
      parser = GitModulesParser.new(@tmpdir)
      
      error = assert_raises(RuntimeError) { parser.parse }
      assert_match(/missing path or url/, error.message)
    end

    def test_parse_raises_error_when_missing_url
      content = <<~GITMODULES
        [submodule "test/module"]
        \tpath = test/module
      GITMODULES
      
      create_gitmodules_file(content)
      parser = GitModulesParser.new(@tmpdir)
      
      error = assert_raises(RuntimeError) { parser.parse }
      assert_match(/missing path or url/, error.message)
    end

    def test_parse_raises_error_when_file_missing
      parser = GitModulesParser.new(@tmpdir)
      
      error = assert_raises(RuntimeError) { parser.parse }
      assert_match(/No .gitmodules file found/, error.message)
    end

    def test_parse_raises_error_on_duplicate_path_key
      content = <<~GITMODULES
        [submodule "test/module"]
        \tpath = path = test/module
        \turl = https://github.com/test/repo.git
      GITMODULES
      
      create_gitmodules_file(content)
      parser = GitModulesParser.new(@tmpdir)
      
      error = assert_raises(RuntimeError) { parser.parse }
      assert_match(/Malformed .gitmodules: duplicate key/, error.message)
      assert_match(/test\/module/, error.message)
    end

    def test_parse_raises_error_on_duplicate_url_key
      content = <<~GITMODULES
        [submodule "test/module"]
        \tpath = test/module
        \turl = url = https://github.com/test/repo.git
      GITMODULES
      
      create_gitmodules_file(content)
      parser = GitModulesParser.new(@tmpdir)
      
      error = assert_raises(RuntimeError) { parser.parse }
      assert_match(/Malformed .gitmodules: duplicate key/, error.message)
      assert_match(/test\/module/, error.message)
    end

    private

    def create_gitmodules_file(content)
      File.write(File.join(@tmpdir, '.gitmodules'), content)
    end
  end
end
