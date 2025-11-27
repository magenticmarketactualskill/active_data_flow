#!/usr/bin/env ruby
# frozen_string_literal: true

# Example demonstrating ActiveRecord connector usage with scopes

require "bundler/setup"
require "active_data_flow"

# This example shows how to use the ActiveRecord connectors
# In a real Rails app, you would have actual models

puts "=== ActiveRecord Source Connector ==="
puts
puts "Sources MUST use named scopes for serializability:"
puts
puts "Basic usage:"
puts <<~RUBY
  # Define scopes in your model
  class User < ApplicationRecord
    scope :active, -> { where(active: true) }
    scope :created_after, ->(date) { where("created_at > ?", date) }
  end
  
  # Create source using the scope
  source = ActiveDataFlow::Connector::Source::ActiveRecordSource.new(
    scope: User.active
  )
  
  # With parameters
  source = ActiveDataFlow::Connector::Source::ActiveRecordSource.new(
    scope: User.created_after(1.week.ago)
  )
RUBY

puts
puts "=== ActiveRecord Sink Connector ==="
puts
puts "The sink writes records to a model:"
puts
puts "Usage:"
puts <<~RUBY
  sink = ActiveDataFlow::Connector::Sink::ActiveRecordSink.new(
    model_class: UserBackup
  )
  
  # Write single record
  sink.write(name: "John", email: "john@example.com")
  
  # Write batch of records (uses insert_all for efficiency)
  sink.write_batch([
    { name: "Jane", email: "jane@example.com" },
    { name: "Bob", email: "bob@example.com" }
  ])
RUBY

puts
puts "=== Complete Data Flow Example ==="
puts
puts "Complete example with named scopes:"
puts <<~RUBY
  # Define a scope in your model
  class User < ApplicationRecord
    scope :recently_active, -> { where("last_login_at > ?", 30.days.ago) }
  end
  
  # Create source using the scope (named scopes are serializable)
  source = ActiveDataFlow::Connector::Source::ActiveRecordSource.new(
    scope: User.recently_active
  )
  
  # Define sink
  sink = ActiveDataFlow::Connector::Sink::ActiveRecordSink.new(
    model_class: UserBackup
  )
  
  # Create data flow with runtime configuration
  # batch_size is configured on the runtime only
  ActiveDataFlow::DataFlow.create!(
    name: "active_users_backup",
    source: source,
    sink: sink,
    runtime_config: {
      batch_size: 100  # Runtime controls how many records to process at once
    }
  )
RUBY

puts
puts "Complex scopes with chaining:"
puts <<~RUBY
  # Define complex scope in your model
  class User < ApplicationRecord
    scope :recently_active_with_profile, -> {
      where(active: true)
        .where("last_login_at > ?", 30.days.ago)
        .includes(:profile)
        .order(:created_at)
    }
  end
  
  # Use the named scope
  source = ActiveDataFlow::Connector::Source::ActiveRecordSource.new(
    scope: User.recently_active_with_profile
  )
RUBY
