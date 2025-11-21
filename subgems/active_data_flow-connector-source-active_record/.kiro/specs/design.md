# ActiveRecord Source Connector Design

## Overview

The ActiveRecord source connector provides a concrete implementation of `ActiveDataFlow::Connector::Source::Base` for reading data from database tables using ActiveRecord models.

See: `parent_requirements.md` - Requirement 3 (ActiveRecord Connector Implementation)
See: `parent_design.md` - Section 3 (Connector Abstractions)
See: `requirements.md` for source-specific requirements

## Architecture

### Class Hierarchy

```
ActiveDataFlow::Connector::Source::Base (from core)
  └── ActiveDataFlow::Connector::Source::ActiveRecord (this gem)
```

### Key Components

1. **Model Resolution**: Converts configuration to ActiveRecord model class
2. **Relation Building**: Applies scopes to base relation
3. **Batch Iteration**: Uses `find_each` for memory efficiency
4. **Message Wrapping**: Converts records to Message instances
5. **Error Handling**: Converts ActiveRecord errors to standard exceptions

## Implementation Details

### Configuration

- `model` (required): ActiveRecord model class, string, or symbol
- `scope` (optional): Proc that receives and returns an ActiveRecord relation
- `batch_size` (optional): Number of records per batch (default: 1000)

### Core Methods

**each**: Yields Message instances for each record
**count**: Returns total number of records respecting scope

### Message Format

```ruby
ActiveDataFlow::Message::Untyped.new(
  { "id" => 1, "name" => "Widget", ... },  # Record attributes
  metadata: { model: "Product", id: 1 }     # Model info
)
```

## Usage Examples

### Basic Usage

```ruby
source = ActiveDataFlow::Connector::Source::ActiveRecord.new(model: Product)
source.each { |message| process(message) }
```

### With Scope

```ruby
source = ActiveDataFlow::Connector::Source::ActiveRecord.new(
  model: "Product",
  scope: ->(r) { r.where(active: true).order(:name) }
)
```

### Custom Batch Size

```ruby
source = ActiveDataFlow::Connector::Source::ActiveRecord.new(
  model: :Product,
  batch_size: 500
)
```

## Performance Considerations

- Uses `find_each` for memory-efficient batching
- Default batch size (1000) balances memory and performance
- Apply filters at database level using scopes
- Use `includes` to avoid N+1 queries

## Testing Strategy

See: `../steering/test_driven_design.md`

- Unit tests for model resolution, relation building, message wrapping
- Integration tests with real database
- Performance tests for large datasets

## Dependencies

- `active_data_flow` (core gem)
- `activerecord` (>= 6.0)

## File Structure

```
subgems/active_data_flow-connector-source-active_record/
├── lib/
│   └── active_data_flow/
│       └── connector/
│           └── source/
│               └── active_record.rb
├── .kiro/
│   ├── specs/
│   │   ├── requirements.md
│   │   ├── design.md (this file)
│   │   └── tasks.md
│   └── steering/ (symlinks to parent)
└── active_dataflow-connector-source-active_record.gemspec
```
