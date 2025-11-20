# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Submoduler parent gem
gem 'submoduler-core-submoduler_parent', git: 'https://github.com/magenticmarketactualskill/submoduler-core-submoduler_parent.git'

# Subgem path references for local development
gem 'active_data_flow-connector-source-active_record', path: 'subgems/active_data_flow-connector-source-active_record'
gem 'active_data_flow-connector-sink-active_record', path: 'subgems/active_data_flow-connector-sink-active_record'
gem 'active_data_flow-runtime-heartbeat', path: 'subgems/active_data_flow-runtime-heartbeat'

gemspec
