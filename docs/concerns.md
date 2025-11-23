# ActiveDataFlow Concerns

This document explains how concerns are loaded and managed in ActiveDataFlow.

## Concerns Loader

The `ActiveDataFlow::Concerns` module provides centralized concern loading functionality.

### Location

Concerns are located in:
- **Engine concerns:** `app/data_flows/concerns/` (in the gem)
- **Host concerns:** `app/data_flows/concerns/` (in the host application)

### Loading Process

Concerns are loaded in this order:

1. **Initial Load** - When the gem is required:
   - Engine concerns are automatically loaded
   - Available immediately for use

2. **Development Reload** - On each request in development:
   - Engine concerns are reloaded
   - Host concerns are reloaded
   - Ensures changes are picked up without restart

### API

#### `ActiveDataFlow::Concerns.load_engine_concerns(engine_root)`

Loads all concerns from the engine's `app/data_flows/concerns/` directory.

**Parameters:**
- `engine_root` - Pathname to the engine root directory

**Example:**
```ruby
engine_root = Pathname.new("/path/to/engine")
ActiveDataFlow::Concerns.load_engine_concerns(engine_root)
```

#### `ActiveDataFlow::Concerns.load_host_concerns(concerns_path)`

Loads all concerns from the specified path (typically host application's concerns).

**Parameters:**
- `concerns_path` - Glob pattern for concern files (e.g., `"app/data_flows/concerns/**/*.rb"`)

**Example:**
```ruby
concerns_path = Rails.root.join("app/data_flows/concerns/**/*.rb")
ActiveDataFlow::Concerns.load_host_concerns(concerns_path)
```

## Creating Concerns

### File Structure

```
app/data_flows/concerns/
├── active_record_2_active_record.rb
├── kafka_2_kafka.rb
└── custom_concern.rb
```

### Naming Convention

- File name: `snake_case.rb`
- Module name: `ActiveDataFlow::CamelCase`

**Example:**
```ruby
# app/data_flows/concerns/my_custom_concern.rb
module ActiveDataFlow
  module MyCustomConcern
    extend ActiveSupport::Concern
    
    included do
      # Instance-level code
    end
    
    class_methods do
      # Class-level methods
    end
  end
end
```

## Built-in Concerns

### ActiveRecord2ActiveRecord

Provides a DSL for defining ActiveRecord-to-ActiveRecord data flows.

**Location:** `app/data_flows/concerns/active_record_2_active_record.rb`

**Usage:**
```ruby
class UserSyncFlow
  include ActiveDataFlow::ActiveRecord2ActiveRecord
  
  source User.where(active: true), batch_size: 100
  sink UserBackup, batch_size: 100
  runtime ActiveDataFlow::Runtime::Base.new(interval: 3600)
  
  register name: "user_sync"
end
```

See `app/data_flows/concerns/README.md` for detailed documentation.

## Error Handling

The concerns loader includes error handling:

- **Load failures** are logged as errors
- **Backtraces** are logged in debug mode
- **Failed concerns** don't prevent other concerns from loading

**Example log output:**
```
Failed to load engine concern app/data_flows/concerns/broken.rb: undefined method 'foo'
```

## Debugging

Enable debug logging to see concern loading:

```ruby
# config/initializers/active_data_flow.rb
ActiveDataFlow.configure do |config|
  config.log_level = :debug
end
```

**Debug output:**
```
Loaded engine concern: /path/to/app/data_flows/concerns/active_record_2_active_record.rb
Loaded host concern: /path/to/host/app/data_flows/concerns/custom_concern.rb
```

## Best Practices

1. **Keep concerns focused** - One responsibility per concern
2. **Use descriptive names** - Clear indication of what the concern does
3. **Document usage** - Include examples in comments
4. **Test concerns** - Write specs for concern behavior
5. **Avoid dependencies** - Concerns should be self-contained

## Testing Concerns

```ruby
# spec/concerns/my_custom_concern_spec.rb
require "spec_helper"

RSpec.describe ActiveDataFlow::MyCustomConcern do
  let(:test_class) do
    Class.new do
      include ActiveDataFlow::MyCustomConcern
    end
  end
  
  it "provides expected methods" do
    expect(test_class).to respond_to(:my_method)
  end
end
```

## Troubleshooting

### Concern Not Found

If you get `uninitialized constant ActiveDataFlow::MyConcern`:

1. Check file exists in `app/data_flows/concerns/`
2. Verify module name matches file name (snake_case → CamelCase)
3. Check for syntax errors in the concern file
4. Enable debug logging to see if concern is being loaded
5. Restart Rails server (concerns are cached in production)

### Concern Not Reloading

In development, if changes aren't picked up:

1. Check `config.cache_classes` is `false`
2. Restart Spring: `spring stop`
3. Clear Rails cache: `rails tmp:clear`
4. Verify `to_prepare` is being called

### Load Order Issues

If concerns depend on each other:

1. Use explicit `require_relative` in the concern file
2. Load dependencies first in the concerns loader
3. Consider refactoring to remove dependencies
