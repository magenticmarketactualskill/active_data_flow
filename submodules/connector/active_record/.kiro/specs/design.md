# ActiveDataFlow ActiveRecord Sink - Design Document

## Overview

The `active_data_flow-active_record` gem provides:

a Sink implementation that writes data to Rails database tables using ActiveRecord. It extends the core `active_data_flow` gem's Sink base class with database persistence capabilities, supporting both single record writes and high-performance batch operations.

a Source implementation that reads data from Rails database tables using ActiveRecord. It extends the core `active_data_flow` gem's Source base class with database persistence capabilities, supporting both single record reads and high-performance batch operations.

## Architecture

### Component Structure

```
active_data_flow-active_record/
├── lib/
│   ├── active_data_flow/
│   │   ├── sink/
│   │   │   └── active_record.rb
│   │   └── source/
│   │       └── active_record.rb
│   └── active_data_flow-active_record.rb
├── spec/
│   └── active_data_flow/
│       ├── sink/
│       │   └── active_record_spec.rb
│       └── source/
│           └── active_record_spec.rb
└── Gemfile
```

### Dependencies

- **active_data_flow (core)**: Provides the base Source and Sink classes
- **activerecord**: Rails ORM for database operations
- **activesupport**: Rails utilities for string manipulation and class resolution

## Components and Interfaces

### ActiveDataFlow::Sink::ActiveRecord

The main sink class that handles writing data to database tables.

**Configuration Options:**
- `model_name` (required): String or symbol representing the ActiveRecord model class name
- `batch_size` (optional): Number of records to buffer before batch insert (default: nil for single writes)
- `upsert` (optional): Boolean to enable upsert mode (default: false)
- `unique_by` (optional): Column(s) for conflict detection in upsert mode
- `update_only` (optional): Array of columns to update in upsert mode
- `transaction` (optional): Boolean to wrap writes in transactions (default: false)
- `transaction_batch_size` (optional): Records per transaction (default: batch_size)
- `skip_callbacks` (optional): Boolean to disable ActiveRecord callbacks (default: false)
- `skip_validations` (optional): Boolean to disable validations (default: false)

**Public Methods:**
- `initialize(config)`: Set up sink with configuration
- `write(record)`: Write a single record or add to batch buffer
- `flush`: Manually flush buffered records
- `close`: Flush remaining records and cleanup

**Private Methods:**
- `resolve_model`: Convert model_name string to ActiveRecord class
- `write_single(record)`: Write one record using create!
- `write_batch(records)`: Write multiple records using insert_all/upsert_all
- `execute_in_transaction(&block)`: Wrap operations in transaction
- `handle_error(error, record)`: Process write errors

**Private Methods:**
- `resolve_model`: Convert model_name string to ActiveRecord class
- `write_single(record)`: Write one record using create!
- `write_batch(records)`: Write multiple records using insert_all/upsert_all
- `execute_in_transaction(&block)`: Wrap operations in transaction
- `handle_error(error, record)`: Process write errors

### ActiveDataFlow::Source::ActiveRecord

The main source class that handles reading data from database tables.

**Configuration Options:**
- `model_name` (required): String or symbol representing the ActiveRecord model class name
- `batch_size` (optional): Number of records to load per batch (default: 1000)
- `where` (optional): Hash or string for filtering records
- `order` (optional): String or hash for sorting records
- `limit` (optional): Maximum number of records to read
- `select` (optional): Array of columns to select
- `includes` (optional): Associations to eager load
- `readonly` (optional): Boolean to mark records as readonly (default: true)

**Public Methods:**
- `initialize(config)`: Set up source with configuration
- `each(&block)`: Iterate through records, yielding each one
- `close`: Cleanup and release resources

**Private Methods:**
- `resolve_model`: Convert model_name string to ActiveRecord class
- `build_query`: Construct ActiveRecord query from configuration
- `iterate_records(&block)`: Execute query and yield records

### Error Handling Strategy

**Sink Errors:**
1. **Validation Errors**: Log and optionally raise or skip
2. **Unique Constraint Violations**: Handle gracefully in upsert mode
3. **Connection Errors**: Retry with exponential backoff
4. **Transaction Rollback**: Automatic on any error within transaction

**Source Errors:**
1. **Query Errors**: Log and raise with context
2. **Connection Errors**: Retry with exponential backoff
3. **Invalid Model**: Raise clear error on model resolution failure
4. **Iteration Errors**: Handle gracefully and log

## Data Models

### Record Format (Sink)

Records passed to `write` method should be Hash objects with keys matching database column names:

```ruby
{
  name: "John Doe",
  email: "john@example.com",
  created_at: Time.now
}
```

### Record Format (Source)

Records yielded by `each` method are ActiveRecord model instances or hashes:

```ruby
# As ActiveRecord instance
user = User.find(1)

# As hash (when using pluck or select)
{ id: 1, name: "John Doe", email: "john@example.com" }
```

### Batch Buffer (Sink)

Internal array storing records until batch_size is reached:

```ruby
@buffer = []
```

### Query Builder (Source)

Internal query object constructed from configuration:

```ruby
@query = model_class.where(config[:where])
                    .order(config[:order])
                    .limit(config[:limit])
```

## Implementation Details

### Sink Implementation

#### Model Resolution

```ruby
def resolve_model
  @model_class ||= @config[:model_name].to_s.constantize
end
```

#### Single Record Write

```ruby
def write_single(record)
  if @config[:skip_validations]
    model_class.insert(record)
  else
    model_class.create!(record)
  end
end
```

#### Batch Write

```ruby
def write_batch(records)
  if @config[:upsert]
    model_class.upsert_all(
      records,
      unique_by: @config[:unique_by],
      update_only: @config[:update_only]
    )
  else
    model_class.insert_all(records)
  end
end
```

#### Transaction Wrapping

```ruby
def execute_in_transaction(&block)
  if @config[:transaction]
    model_class.transaction(&block)
  else
    yield
  end
end
```

### Source Implementation

#### Model Resolution

```ruby
def resolve_model
  @model_class ||= @config[:model_name].to_s.constantize
end
```

#### Query Building

```ruby
def build_query
  query = model_class.all
  query = query.where(@config[:where]) if @config[:where]
  query = query.order(@config[:order]) if @config[:order]
  query = query.limit(@config[:limit]) if @config[:limit]
  query = query.select(@config[:select]) if @config[:select]
  query = query.includes(@config[:includes]) if @config[:includes]
  query = query.readonly if @config[:readonly]
  query
end
```

#### Record Iteration

```ruby
def iterate_records(&block)
  if @config[:batch_size]
    build_query.find_each(batch_size: @config[:batch_size], &block)
  else
    build_query.each(&block)
  end
end
```

## Error Handling

### Sink Error Handling

#### Validation Errors

- Log error details with record information
- Optionally skip record and continue processing
- Raise exception if configured for strict mode

#### Database Errors

- Catch ActiveRecord::RecordNotUnique for duplicate key violations
- Catch ActiveRecord::ConnectionTimeoutError for connection issues
- Implement retry logic with configurable attempts

#### Transaction Failures

- Automatic rollback on any exception
- Log transaction failure details
- Re-raise exception after rollback

### Source Error Handling

#### Query Errors

- Catch ActiveRecord::StatementInvalid for SQL errors
- Log query details and error message
- Raise with clear context

#### Connection Errors

- Catch ActiveRecord::ConnectionTimeoutError
- Implement retry logic with exponential backoff
- Log connection issues

#### Model Resolution Errors

- Catch NameError for invalid model names
- Provide clear error message with model name
- Raise immediately without retry

## Testing Strategy

### Sink Unit Tests

1. **Configuration Tests**
   - Validate required config parameters
   - Test default values
   - Test invalid configurations

2. **Model Resolution Tests**
   - Test string to class conversion
   - Test invalid model names
   - Test namespaced models

3. **Single Write Tests**
   - Test successful record creation
   - Test validation errors
   - Test with skip_validations option

4. **Batch Write Tests**
   - Test buffering behavior
   - Test automatic flush at batch_size
   - Test manual flush
   - Test insert_all usage

5. **Upsert Tests**
   - Test upsert_all with unique_by
   - Test update_only behavior
   - Test conflict handling

6. **Transaction Tests**
   - Test transaction wrapping
   - Test rollback on errors
   - Test commit on success

7. **Error Handling Tests**
   - Test validation error handling
   - Test unique constraint violations
   - Test connection errors

### Source Unit Tests

1. **Configuration Tests**
   - Validate required config parameters
   - Test default values
   - Test query configuration options

2. **Model Resolution Tests**
   - Test string to class conversion
   - Test invalid model names
   - Test namespaced models

3. **Query Building Tests**
   - Test where clause application
   - Test order clause application
   - Test limit application
   - Test select column filtering
   - Test includes for eager loading

4. **Batch Reading Tests**
   - Test find_each with batch_size
   - Test memory efficiency
   - Test batch boundaries

5. **Iteration Tests**
   - Test each method yields records
   - Test record format
   - Test empty result sets

6. **Error Handling Tests**
   - Test query errors
   - Test connection errors
   - Test model resolution errors

### Test Database Setup

- Use in-memory SQLite for fast tests
- Create test models and migrations
- Use database_cleaner for test isolation
- Seed test data for source tests

### Test Fixtures

```ruby
class TestUser < ActiveRecord::Base
end

RSpec.describe ActiveDataFlow::Sink::ActiveRecord do
  let(:config) { { model_name: 'TestUser' } }
  let(:sink) { described_class.new(config) }
  
  # Test cases...
end

RSpec.describe ActiveDataFlow::Source::ActiveRecord do
  let(:config) { { model_name: 'TestUser' } }
  let(:source) { described_class.new(config) }
  
  before do
    TestUser.create!(name: 'User 1', email: 'user1@example.com')
    TestUser.create!(name: 'User 2', email: 'user2@example.com')
  end
  
  # Test cases...
end
```

## Performance Considerations

### Sink Performance

1. **Batch Size Tuning**: Larger batches improve throughput but increase memory usage
2. **Skip Callbacks**: Significant performance gain for bulk inserts
3. **Skip Validations**: Use only for trusted data sources
4. **Transaction Batching**: Balance between consistency and performance
5. **Connection Pooling**: Leverage Rails connection pool for concurrent writes

### Source Performance

1. **Batch Size Tuning**: Use find_each with appropriate batch_size for large datasets
2. **Column Selection**: Use select to load only needed columns
3. **Eager Loading**: Use includes to avoid N+1 queries
4. **Readonly Mode**: Mark records as readonly to skip dirty tracking
5. **Index Usage**: Ensure proper indexes on where and order columns

## Security Considerations

1. **SQL Injection**: ActiveRecord parameterization prevents injection
2. **Mass Assignment**: Use strong parameters or attribute whitelisting
3. **Validation Bypass**: Only skip validations for trusted data
4. **Connection Security**: Use encrypted connections for sensitive data
