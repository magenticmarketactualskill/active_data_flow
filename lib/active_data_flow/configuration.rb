# frozen_string_literal: true

module ActiveDataFlow
  class Configuration
    attr_accessor :auto_load_data_flows, :log_level, :data_flows_path

    def initialize
      @auto_load_data_flows = true
      @log_level = :info
      @data_flows_path = "app/data_flows"
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
