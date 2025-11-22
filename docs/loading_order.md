# ActiveDataFlow Loading Order

This document explains when and how ActiveDataFlow components are loaded.

## Loading Sequence

ActiveDataFlow uses a carefully orchestrated loading sequence to ensure all dependencies are available before data flows are loaded.

### 1. Rails Initialization Phase

During `Rails::Application#initialize`:
- ✅ ActiveDataFlow gem is loaded
- ✅ Engine is registered
- ✅ Base classes are loaded (Source, Sink, Runtime)
- ❌ Data flows are NOT loaded yet

### 2. After Initialization Phase

After `Rails::Application#initialize` completes (via `config.after_initialize`):
- ✅ All Rails components are loaded (ActiveRecord, models, etc.)
- ✅ All gems are loaded
- ✅ Application is fully initialized

### 3. Data Flow Loading Phase

Only after the application is fully initialized (via `config.to_prepare`):
1. Engine concerns are loaded (`app/data_flows/concerns/**/*.rb` in engine)
2. Host concerns are loaded (`app/data_flows/concerns/**/*.rb` in host app)
3. Data flows are loaded (`app/data_flows/**/*_flow.rb` in host app)

## Why This Order Matters

### Problem: Loading Too Early

If data flows were loaded during `Rails::Application#initialize`:
- Models might not be loaded yet
- Database connections might not be established
- Other gems might not be initialized
- Autoloading might not work correctly

### Solution: Load After Initialization

By loading data flows after initialization:
- All models are available
- Database is connected
- All gems are loaded
- Autoloading works correctly
- Data flows can safely reference any application code

## Development Mode

In development mode, `config.to_prepare` runs before each request, ensuring:
- Data flows are reloaded when changed
- Concerns are reloaded when changed
- Changes are picked up without restarting the server

## Production Mode

In production mode, `config.to_prepare` runs once at startup:
- Data flows are loaded once
- No reloading overhead
- Optimal performance

## Disabling Auto-Loading

If you need to control when data flows are loaded:

```ruby
# config/initializers/active_data_flow.rb
ActiveDataFlow.configure do |config|
  config.auto_load_data_flows = false
end
```

Then manually load data flows when needed:

```ruby
# Load a specific data flow
load Rails.root.join("app/data_flows/user_sync_flow.rb")

# Or load all data flows
Dir[Rails.root.join("app/data_flows/**/*_flow.rb")].each { |f| load f }
```

## Troubleshooting

### Data Flow Not Loading

Check:
1. Is the file in `app/data_flows/` with `_flow.rb` suffix?
2. Is `auto_load_data_flows` enabled in configuration?
3. Check Rails logs for loading errors
4. Set `log_level: :debug` to see detailed loading information

### Dependency Not Available

If a data flow references a model or class that isn't loaded:
1. Ensure the class is in the correct autoload path
2. Check that the class is defined before the data flow loads
3. Consider using a string reference instead of a constant
4. Use `ActiveSupport.on_load` hooks if needed

## Best Practices

1. **Keep data flows simple** - Complex initialization logic should be in models
2. **Use named scopes** - Define scopes in models, reference them in data flows
3. **Avoid side effects** - Data flow loading should not trigger database queries
4. **Use lazy evaluation** - Don't execute queries at load time, only when running
5. **Test loading** - Ensure data flows can be loaded without errors
