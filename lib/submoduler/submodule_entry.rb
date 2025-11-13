# frozen_string_literal: true

module Submoduler
  # Represents a parsed submodule entry from .gitmodules
  class SubmoduleEntry
    attr_reader :name, :path, :url

    def initialize(name:, path:, url:)
      @name = name
      @path = path
      @url = url
    end

    def to_s
      "#{name} (#{path})"
    end
  end
end
