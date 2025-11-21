#!/usr/bin/env ruby
# frozen_string_literal: true

# Example demonstrating how to create a data flow with object instances

require "bundler/setup"
require "active_data_flow"

# Create source instance
source = ActiveDataFlow::Connector::Source::Base.new(
  model: "User",
  batch_size: 100
)

# Create sink instance
sink = ActiveDataFlow::Connector::Sink::Base.new(
  model: "UserBackup",
  batch_size: 50
)

# Create runtime instance
runtime = ActiveDataFlow::Runtime::Base.new(
  interval: 60,
  max_retries: 3
)

puts "Source: #{source.class.name}"
puts "Source options: #{source.as_json.inspect}"
puts

puts "Sink: #{sink.class.name}"
puts "Sink options: #{sink.as_json.inspect}"
puts

puts "Runtime: #{runtime.class.name}"
puts "Runtime options: #{runtime.as_json.inspect}"
puts

# Demonstrate serialization
puts "=== Serialization Test ==="
serialized = {
  class: source.class.name,
  data: source.as_json
}.to_json
puts "Serialized: #{serialized}"
puts

data = JSON.parse(serialized)
klass = Object.const_get(data["class"])
deserialized = klass.from_json(data["data"])
puts "Deserialized: #{deserialized.class.name}"
puts "Deserialized options: #{deserialized.as_json.inspect}"
puts

puts "=== In a Rails App ==="
puts "You would create a DataFlow like this:"
puts <<~RUBY
  ActiveDataFlow::DataFlow.create!(
    name: "user_sync",
    source: source,
    sink: sink,
    runtime: runtime
  )
RUBY
