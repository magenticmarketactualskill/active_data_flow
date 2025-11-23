# frozen_string_literal: true

require "rails/generators"
require "rails/generators/migration"

module ActiveDataFlow
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def copy_migrations
        migration_template "create_active_data_flow_data_flows.rb",
                          "db/migrate/create_active_data_flow_data_flows.rb"
      end

      def create_data_flows_directory
        empty_directory "app/data_flows"
        create_file "app/data_flows/.keep"
      end

      def copy_initializer
        copy_file "active_data_flow_initializer.rb",
                  "config/initializers/active_data_flow.rb"
      end

      def mount_engine
        route 'mount ActiveDataFlow::Engine => "/active_data_flow"'
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
