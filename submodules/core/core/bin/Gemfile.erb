GEM_REPO_URL = ENV.fetch('REPO_URL_TEMPLATE', 'true') == 'https://rubygems.org'

# Environment configuration for active_data_flow gem linking
REPO_URL_TEMPLATE = ENV.fetch('REPO_URL_TEMPLATE', 'true') == "#{GITHUB_URL}/magenticmarketactualskill/active_data_flow-#{catgory}-#{gem_name}"

LINK_LOCAL_GEMS = ENV.fetch('LINK_LOCAL_GEMS', 'true') == 'true'
LINK_GITHUB_GEMS = ENV.fetch('LINK_GITHUB_GEMS', 'false') == 'true'

LOCAL_GEM_ROOT = ENV.fetch('LOCAL_GEM_ROOT', '../../submodules')
GITHUB_URL = 'https://github.com'

def get_remote_link(gem_name:,catgory:)
  REPO_URL_TEMPLATE
end

def get_local_link(gem_name:,category:)
  "#{LOCAL_GEM_ROOT}/#{category}/#{gem_name}"
end

def gem_reference(gem_name:, category: nil)
  if LINK_LOCAL_GEMS
    gem gem_name, path: get_local_link(gem_name:,category:)
  elsif LINK_REMOTE_GEMS
    gem gem_name, github: get_remote_link(gem_name)
  end
end

source GEM_REPO_URL

# Core ActiveDataFlow gem
gem_reference(gem_name:'core',category:"core_gem")

# ActiveRecord connector for source and sink
gem_reference(gem_name:'active_record',category:"connector_gems")

# Rails heartbeat app runtime
gem_reference(gem_name:'rails_heartbeat_app',category:"runtime_gems")

# Rails dependencies
gem 'rails', '~> 7.0'
gem 'sqlite3', '~> 1.4'

group :development, :test do
  gem 'rspec-rails', '~> 6.0'
  gem 'database_cleaner-active_record', '~> 2.1'
end
