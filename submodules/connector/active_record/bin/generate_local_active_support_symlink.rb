#!/usr/bin/env ruby
require 'fileutils'

# Define paths
script_dir = __dir__
connector_root = File.expand_path('..', script_dir)
target_dir = File.join(connector_root, 'local', 'active_data_flow')
source_dir = File.expand_path('../../../core/core/lib/active_data_flow', script_dir)

# Remove existing symlink or directory if it exists
if File.exist?(target_dir) || File.symlink?(target_dir)
  FileUtils.rm_rf(target_dir)
  puts "✓ Removed existing #{target_dir}"
end

# Ensure the local directory exists
FileUtils.mkdir_p(File.dirname(target_dir))

# Create the symlink
File.symlink(source_dir, target_dir)

puts "✓ Created symlink: #{target_dir} -> #{source_dir}"
puts "  Full path: #{File.expand_path(target_dir)}"
