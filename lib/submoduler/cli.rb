# frozen_string_literal: true

require_relative 'report_command'

module Submoduler
  # Command line interface for submoduler tool
  class CLI
    def self.run(args)
      new(args).run
    end

    def initialize(args)
      @args = args
      @repo_root = Dir.pwd
    end

    def run
      # Check for help flag
      if @args.include?('--help') || @args.include?('-h')
        show_usage
        return 0
      end

      # Verify we're in a git repository
      unless git_repository?
        puts "Error: Not a git repository"
        puts "Please run this command from the root of a git repository"
        return 2
      end

      # Parse command
      command = parse_command(@args)

      case command
      when 'report'
        ReportCommand.new(@repo_root).execute
      when nil
        show_usage
        0
      else
        puts "Error: Unknown command '#{command}'"
        puts ""
        show_usage
        2
      end
    rescue StandardError => e
      puts "Fatal error: #{e.message}"
      puts e.backtrace if ENV['DEBUG']
      2
    end

    private

    def parse_command(args)
      args.first
    end

    def git_repository?
      File.directory?(File.join(@repo_root, '.git'))
    end

    def show_usage
      puts <<~USAGE
        Submoduler - Git Submodule Configuration Tool

        Usage:
          submoduler.rb <command> [options]

        Commands:
          report        Generate a validation report for submodule configuration

        Options:
          --help, -h    Show this help message

        Examples:
          submoduler.rb report
          submoduler.rb --help

        Description:
          The 'report' command validates your git submodule configuration by:
          1. Checking that .gitmodules file exists and is properly formatted
          2. Verifying that configured paths exist in the filesystem
          3. Confirming that submodule directories are properly initialized

        Exit Codes:
          0 - All checks passed or no submodules configured
          1 - One or more validation checks failed
          2 - Script error (not a git repo, invalid arguments, etc.)
      USAGE
    end
  end
end
