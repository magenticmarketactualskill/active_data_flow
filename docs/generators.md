# ActiveDataFlow Generators

This document explains the available Rails generators for ActiveDataFlow.

## Available Generators

### Install Generator

Installs ActiveDataFlow in your Rails application.

```bash
rails generate active_data_flow:install
```

**What it does:**
- Creates migration for `active_data_flow_data_flows` table
- Creates `app/data_flows/` directory
- Copies configuration initializer to `config/initializers/active_data_flow.rb`
- Mounts the engine in `config/routes.rb`
- Displays setup instructions

**After running:**
```bash
rails db:migrate
```

### Data Flow Generator

Generates a new data flow class.

```bash
rails generate active_data_flow:data_flow NAME
```

**Example:**
```bash
rails generate active_data_flow:data_flow user_sync
```

**Creates:**
- `app/data_flows/user_sync_flow.rb`

**Generated file structure:**
```ruby
class UserSyncFlow
  def self.register
    source = ActiveDataFlow::Connector::Source::ActiveRecordSource.new(...)
    sink = ActiveDataFlow::Connector::Sink::ActiveRecordSink.new(...)
    
    ActiveDataFlow::DataFlow.find_or_create(
      name: "user_sync",
      source: source,
      sink: sink
    )
  end
end
```

## Viewing Available Generators

To see all ActiveDataFlow generators:

```bash
rails generate --help | grep active_data_flow
```

Output:
```
  active_data_flow:data_flow
  active_data_flow:install
```

## Generator Options

All generators support standard Rails generator options:

- `--force` - Overwrite existing files
- `--pretend` - Show what would be generated without creating files
- `--quiet` - Suppress output
- `--skip` - Skip files that already exist

**Example:**
```bash
rails generate active_data_flow:data_flow user_sync --pretend
```

## Testing Generators

Generators are only available when the gem is installed in a Rails application. They won't show up when running `rails generate` from the gem directory itself.

To test generators:
1. Install the gem in a Rails app
2. Run `bundle install`
3. Run `rails generate --help` to see available generators

## Troubleshooting

### Generators Not Showing Up

If generators don't appear in `rails generate --help`:

1. **Check gem installation:**
   ```bash
   bundle list | grep active_data_flow
   ```

2. **Restart Spring (if using):**
   ```bash
   spring stop
   ```

3. **Clear Rails cache:**
   ```bash
   rails tmp:clear
   ```

4. **Verify gem is in Gemfile:**
   ```ruby
   gem 'active_data_flow', path: '../active_data_flow'
   # or
   gem 'active_data_flow'
   ```

### Generator Fails

If a generator fails:

1. Check Rails version compatibility (requires Rails 6.0+)
2. Ensure database is configured
3. Check file permissions
4. Review error messages for specific issues

## Custom Generators

To create custom generators for your data flows:

```ruby
# lib/generators/my_app/data_flow_generator.rb
module MyApp
  module Generators
    class DataFlowGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      
      def create_custom_data_flow
        # Your custom logic
      end
    end
  end
end
```

Register in your application:
```ruby
# config/application.rb
config.generators do |g|
  g.test_framework :rspec
end
```
