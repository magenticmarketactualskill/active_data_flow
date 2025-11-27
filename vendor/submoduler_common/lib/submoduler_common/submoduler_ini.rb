# frozen_string_literal: true

module SubmodulerCommon
  # Parser and accessor for .submoduler.ini configuration files
  # Provides a unified interface for reading submoduler configuration
  class SubmodulerIni
    class ConfigError < StandardError; end
    class NotFoundError < ConfigError; end
    class InvalidFormatError < ConfigError; end

    attr_reader :path, :config

    # Initialize with path to .submoduler.ini file
    # @param path [String] Path to .submoduler.ini file (default: '.submoduler.ini')
    def initialize(path = '.submoduler.ini')
      @path = path
      @config = {}
      load_config if File.exist?(@path)
    end

    # Check if config file exists
    # @return [Boolean]
    def exist?
      File.exist?(@path)
    end

    # Load and parse the configuration file
    # @raise [NotFoundError] if file doesn't exist
    # @raise [InvalidFormatError] if file format is invalid
    def load_config
      raise NotFoundError, "Config file not found: #{@path}" unless exist?

      @config = parse_ini_file(File.read(@path))
    end

    # Get the type of this repository (parent or child)
    # @return [Symbol] :parent or :child
    def type
      return :child if config.dig('submoduler', 'type') == 'child'
      return :child if config.dig('submoduler', 'childname')
      :parent
    end

    # Check if this is a parent repository
    # @return [Boolean]
    def parent?
      type == :parent
    end

    # Check if this is a child repository
    # @return [Boolean]
    def child?
      type == :child
    end

    # Get the master/parent repository URL
    # @return [String, nil]
    def master_url
      config.dig('default', 'master') || config.dig('submoduler', 'master')
    end

    # Get the child name (for child repositories)
    # @return [String, nil]
    def child_name
      config.dig('submoduler', 'childname')
    end

    # Get all submodules defined in the config
    # @return [Array<Hash>] Array of submodule hashes with :name, :path, :url
    def submodules
      config.select { |key, _| key.start_with?('submodule ') }.map do |key, values|
        name = key.match(/submodule "(.+)"/)[1]
        {
          name: name,
          path: values['path'],
          url: values['url']
        }
      end
    end

    # Get a specific submodule by name
    # @param name [String] Submodule name
    # @return [Hash, nil] Submodule hash or nil if not found
    def submodule(name)
      submodules.find { |sm| sm[:name] == name }
    end

    # Get a specific submodule by path
    # @param path [String] Submodule path
    # @return [Hash, nil] Submodule hash or nil if not found
    def submodule_by_path(path)
      submodules.find { |sm| sm[:path] == path }
    end

    # Get a value from the config
    # @param section [String] Section name
    # @param key [String] Key name
    # @return [String, nil] Value or nil if not found
    def get(section, key)
      config.dig(section, key)
    end

    # Validate parent repository configuration
    # @raise [InvalidFormatError] if configuration is invalid
    def validate_parent!
      raise InvalidFormatError, "Missing 'master' configuration" unless master_url
    end

    # Validate child repository configuration
    # @raise [InvalidFormatError] if configuration is invalid
    def validate_child!
      raise InvalidFormatError, "Missing 'childname' configuration" unless child_name
    end

    # Find the project root by searching for .submoduler.ini
    # @param start_dir [String] Directory to start searching from (default: current directory)
    # @return [String] Path to project root
    # @raise [NotFoundError] if .submoduler.ini not found
    def self.find_project_root(start_dir = Dir.pwd)
      current_dir = start_dir

      while current_dir != '/'
        config_path = File.join(current_dir, '.submoduler.ini')
        return current_dir if File.exist?(config_path)

        current_dir = File.dirname(current_dir)
      end

      raise NotFoundError, "Could not find project root (no .submoduler.ini found)"
    end

    # Create a new SubmodulerIni instance from project root
    # @param start_dir [String] Directory to start searching from (default: current directory)
    # @return [SubmodulerIni]
    def self.from_project_root(start_dir = Dir.pwd)
      root = find_project_root(start_dir)
      new(File.join(root, '.submoduler.ini'))
    end

    private

    # Parse INI file content into a hash
    # @param content [String] INI file content
    # @return [Hash] Parsed configuration
    def parse_ini_file(content)
      result = {}
      current_section = nil

      content.each_line do |line|
        line = line.strip

        # Skip empty lines and comments
        next if line.empty? || line.start_with?('#', ';')

        # Section header
        if line =~ /^\[(.+)\]$/
          current_section = $1
          result[current_section] = {}
        # Key-value pair
        elsif line =~ /^(.+?)\s*=\s*(.+)$/ && current_section
          key = $1.strip
          value = $2.strip
          result[current_section][key] = value
        end
      end

      result
    end
  end
end
