# frozen_string_literal: true

module Submoduler
  # Formats configuration overrides for display in reports
  class ConfigurationReportFormatter
    def initialize(entries, parent_defaults)
      @entries = entries
      @parent_defaults = parent_defaults
    end

    def format
      return "" if @entries.empty? || @parent_defaults.empty?

      overrides_by_key = group_overrides_by_key
      return "" if overrides_by_key.empty?

      output = ["\n=== Configuration Overrides ===\n"]

      overrides_by_key.each do |key, overrides|
        output << "\n#{key}:"
        output << "  Parent default: #{@parent_defaults[key]}"
        output << ""
        
        overrides.each do |override|
          output << "  #{override[:name]} → #{override[:value]}"
        end
      end

      output.join("\n")
    end

    private

    def group_overrides_by_key
      overrides_by_key = {}

      @entries.each do |entry|
        next if entry.config_overrides.empty?

        entry.config_overrides.each do |key|
          overrides_by_key[key] ||= []
          overrides_by_key[key] << {
            name: entry.name,
            value: entry.config[key]
          }
        end
      end

      overrides_by_key
    end
  end
end
