# frozen_string_literal: true

require_relative 'validation_result'

module Submoduler
  # Validates that submodule directories are properly initialized
  class InitValidator
    def initialize(repo_root, submodule_entries)
      @repo_root = repo_root
      @entries = submodule_entries
    end

    def validate
      results = []

      @entries.each do |entry|
        results << validate_entry(entry)
      end

      results
    end

    private

    def validate_entry(entry)
      full_path = File.join(@repo_root, entry.path)

      # If directory doesn't exist, skip initialization check
      unless File.directory?(full_path)
        return ValidationResult.new(
          submodule_name: entry.name,
          check_type: :initialization,
          status: :fail,
          message: "Cannot check initialization: directory does not exist"
        )
      end

      # Check if directory is empty
      if check_directory_empty(full_path)
        return ValidationResult.new(
          submodule_name: entry.name,
          check_type: :initialization,
          status: :fail,
          message: "Submodule not checked out: directory is empty"
        )
      end

      # Check if .git exists
      if check_git_present(full_path)
        ValidationResult.new(
          submodule_name: entry.name,
          check_type: :initialization,
          status: :pass,
          message: "Submodule is initialized"
        )
      else
        ValidationResult.new(
          submodule_name: entry.name,
          check_type: :initialization,
          status: :fail,
          message: "Submodule not initialized: .git file/directory not found"
        )
      end
    end

    def check_git_present(path)
      git_file = File.join(path, '.git')
      File.exist?(git_file)
    end

    def check_directory_empty(path)
      Dir.empty?(path)
    rescue Errno::EACCES
      false # If we can't read it, assume it's not empty
    end
  end
end
