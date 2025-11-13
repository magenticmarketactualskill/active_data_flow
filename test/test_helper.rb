# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'
require 'tmpdir'

# Add lib to load path
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
