#!/usr/bin/env ruby
require 'erb'
require 'pathname'

# Determine the connector root directory (parent of bin)
connector_root = File.expand_path('..', __dir__)

# Read the preamble and template files from bin directory
preamble_path = File.join(__dir__, 'Gemfile_preamble.rb')
template_path = File.join(__dir__, 'Gemfile.erb')

# Check if local files exist, otherwise use root bin files
unless File.exist?(preamble_path)
  preamble_path = File.expand_path('../../../bin/Gemfile_preamble.rb', __dir__)
end

unless File.exist?(template_path)
  template_path = File.expand_path('../../../bin/Gemfile.erb', __dir__)
end

preamble = File.read(preamble_path)
template = File.read(template_path)

# Combine preamble and template
combined_content = preamble + "\n" + template

# Process the ERB template
erb = ERB.new(combined_content)
result = erb.result

# Write the generated Gemfile to the connector root directory
File.write(File.join(connector_root, 'Gemfile'), result)

puts "✓ Generated Gemfile from Gemfile.erb template"
