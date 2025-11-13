# frozen_string_literal: true

require 'pathname'
require_relative 'validation_result'

module Submoduler
  # Validates that submodule paths exist and are correctly configured
  class PathValidator
    def initialize(repo_root, submodule_entries)
      @repo_root = repo_root
      @entries = submodule_entries
    end

    def validate
      results = []

      @entries.each do |entry|
        results.concat(validate_entry(entry))
      end

      results
    end

    private

    def validate_entry(entry)
      results = []

      # Check if path is relative
      unless check_path_is_relative(entry.path)
        results << ValidationResult.new(
          submodule_name: entry.name,
          check_type: :path_relative,
          status: :fail,
          message: "Path is not relative: #{entry.path}"
        )
      end

      # Check if path exists
      full_path = File.join(@repo_root, entry.path)
      if check_path_exists(full_path)
        results << ValidationResult.new(
          submodule_name: entry.name,
          check_type: :path_exists,
          status: :pass,
          message: "Directory exists: #{entry.path}"
        )
      else
        results << ValidationResult.new(
          submodule_name: entry.name,
          check_type: :path_exists,
          status: :fail,
          message: "Directory not found: #{entry.path}"
        )
      end

      results
    end

    def check_path_exists(full_path)
      File.directory?(full_path)
    end

    def check_path_is_relative(path)
      !Pathname.new(path).absolute?
    end
  end
end
