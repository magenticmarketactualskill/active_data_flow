#!/usr/bin/env ruby
# frozen_string_literal: true

# Get the project root directory
project_root = File.expand_path('..', __dir__)

# Add the submoduler_parent lib directory to load path
$LOAD_PATH.unshift File.join(project_root, 'vendor', 'submoduler_parent', 'lib')

require 'submoduler_parent'

# Run CLI and exit with returned code
exit SubmodulerParent::CLI.run(ARGV)