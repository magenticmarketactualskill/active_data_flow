#!/usr/bin/env ruby
require 'erb'
require 'pathname'

# Determine the root directory (parent of bin)
root_dir = File.expand_path('..', __dir__)

# Read the preamble and template files
preamble = File.read(File.join(__dir__, 'Gemfile_preamble.rb'))
template = File.read(File.join(__dir__, 'Gemfile.erb'))

# Combine preamble and template
combined_content = preamble + "\n" + template

# Process the ERB template
erb = ERB.new(combined_content)
result = erb.result

# Write the generated Gemfile to the root directory
File.write(File.join(root_dir, 'Gemfile'), result)

puts "✓ Generated Gemfile from Gemfile.erb template"
