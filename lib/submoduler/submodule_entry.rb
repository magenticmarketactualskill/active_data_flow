# frozen_string_literal: true

module Submoduler
  # Represents a parsed submodule entry from .gitmodules or .submoduler.ini
  class SubmoduleEntry
    attr_reader :name, :path, :url, :parent_url, :config, :config_overrides

    def initialize(name:, path:, url:, parent_url: nil, config: {}, config_overrides: [])
      @name = name
      @path = path
      @url = url
      @parent_url = parent_url
      @config = config
      @config_overrides = config_overrides
    end

    def require_test?
      parse_boolean(@config['require_test'])
    end

    def to_s
      "#{name} (#{path})"
    end

    private

    def parse_boolean(value)
      return false if value.nil?
      value.to_s.downcase == 'true'
    end
  end
end
