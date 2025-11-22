# ActiveDataFlow Concerns

This directory contains reusable concerns for defining data flows.

## ActiveRecord2ActiveRecord

A concern that provides a DSL for defining ActiveRecord-to-ActiveRecord data flows.

### Usage

```ruby
class UserSyncFlow
  include ActiveDataFlow::ActiveRecord2ActiveRecord

  # Define source scope
  source User.where(active: true).order(:created_at), batch_size: 100

  # Define destination model
  sink UserBackup, batch_size: 100

  # Define runtime (optional)
  runtime ActiveDataFlow::Runtime::Base.new(interval: 3600)

  # Register the data flow
  register name: "user_sync"
end
```

### Methods

#### `source(scope, config = {})`

Defines the source for the data flow.

**Parameters:**
- `scope` - An ActiveRecord relation to read from
- `config` - Configuration hash
  - `:batch_size` - Number of records to process at once (default: 100)

**Example:**
```ruby
source User.where(active: true), batch_size: 50
```

#### `sink(model_class, config = {})`

Defines the sink for the data flow.

**Parameters:**
- `model_class` - The ActiveRecord model class to write to
- `config` - Configuration hash
  - `:batch_size` - Number of records to write at once (default: 100)

**Example:**
```ruby
sink UserBackup, batch_size: 50
```

#### `runtime(runtime_instance)`

Defines the runtime for the data flow.

**Parameters:**
- `runtime_instance` - An instance of a runtime class

**Example:**
```ruby
runtime ActiveDataFlow::Runtime::Base.new(interval: 3600)
```

#### `register(name:)`

Registers the data flow in the database.

**Parameters:**
- `name` - Unique name for the data flow

**Example:**
```ruby
register name: "user_sync"
```

#### `execute`

Executes the data flow immediately.

**Example:**
```ruby
UserSyncFlow.execute
```

### Benefits

- **Cleaner syntax** - DSL-style definition instead of manual instantiation
- **Less boilerplate** - Automatically creates connector instances
- **Consistent pattern** - All ActiveRecord flows follow the same structure
- **Easy to read** - Clear declaration of source, sink, and runtime

### When to Use

Use this concern when:
- Both source and sink are ActiveRecord models
- You want a simple, declarative syntax
- You don't need custom connector logic

For more complex scenarios, define connectors manually without the concern.
