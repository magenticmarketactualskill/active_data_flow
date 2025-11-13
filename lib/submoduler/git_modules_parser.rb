# frozen_string_literal: true

require_relative 'submodule_entry'

module Submoduler
  # Parses .gitmodules file and extracts submodule configuration
  class GitModulesParser
    attr_reader :repo_root, :gitmodules_path

    def initialize(repo_root)
      @repo_root = repo_root
      @gitmodules_path = File.join(repo_root, '.gitmodules')
    end

    def exists?
      File.exist?(@gitmodules_path)
    end

    def parse
      raise "No .gitmodules file found at #{@gitmodules_path}" unless exists?

      content = File.read(@gitmodules_path)
      parse_content(content)
    rescue Errno::EACCES => e
      raise "Permission denied reading .gitmodules: #{e.message}"
    rescue StandardError => e
      raise "Error reading .gitmodules: #{e.message}"
    end

    private

    def parse_content(content)
      entries = []
      current_entry = {}

      content.each_line do |line|
        line = line.strip

        # Match [submodule "name"]
        if line =~ /^\[submodule\s+"([^"]+)"\]$/
          # Save previous entry if exists
          entries << create_entry(current_entry) if current_entry[:name]
          
          # Start new entry
          current_entry = { name: Regexp.last_match(1) }
        elsif line =~ /^\s*path\s*=\s*(.+)$/
          value = Regexp.last_match(1).strip
          # Detect malformed entries like "path = path = value"
          if value =~ /^(path|url)\s*=/
            raise "Malformed .gitmodules: duplicate key in '#{line}' for submodule '#{current_entry[:name]}'"
          end
          current_entry[:path] = value
        elsif line =~ /^\s*url\s*=\s*(.+)$/
          value = Regexp.last_match(1).strip
          # Detect malformed entries like "url = url = value"
          if value =~ /^(path|url)\s*=/
            raise "Malformed .gitmodules: duplicate key in '#{line}' for submodule '#{current_entry[:name]}'"
          end
          current_entry[:url] = value
        end
      end

      # Don't forget the last entry
      entries << create_entry(current_entry) if current_entry[:name]

      entries
    end

    def create_entry(entry_hash)
      unless entry_hash[:path] && entry_hash[:url]
        raise "Malformed submodule entry: #{entry_hash[:name]} is missing path or url"
      end

      SubmoduleEntry.new(
        name: entry_hash[:name],
        path: entry_hash[:path],
        url: entry_hash[:url]
      )
    end
  end
end
