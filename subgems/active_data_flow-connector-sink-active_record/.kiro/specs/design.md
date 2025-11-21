# ActiveRecord Sink Connector Design

## Overview

The ActiveRecord sink connector provides a concrete implementation of `ActiveDataFlow::Connector::Sink::Base` for writing data to database tables using ActiveRecord models.

See: `parent_requirements.md` - Requirement 3 (ActiveRecord Connector Implementation)
See: `parent_design.md` - Section 3 (Connector Abstractions)
See: `requirements.md` for sink-specific requirements

## Architecture

### Class Hierarchy

```
ActiveDataFlow::Connector::Sink::Base (from core)
  └── ActiveDataFlow::Connector::Sink::ActiveRecord (this gem)
```

### Key Components

1. **Model Resolution**: Converts configuration to ActiveRecord model class
2. **Data Extraction**: Extracts writable data from various input formats
3. **Write Operations**: Single and batch write methods
4. **Error Handling**: Converts ActiveRecord errors to standard exceptions

## Implementation Details

### Configuration

- `model` (required): ActiveRecord model class, string, or symbol

### Core Methods

**write(record)**: Writes a single record to the database
**write_batch(records)**: Writes multiple records efficiently using `insert_all`

### Supported Input Formats

- `Hash` - Direct data
- `ActiveDataFlow::Message::Untyped` - Extracts `.data`
- `ActiveDataFlow::Message::Typed` - Extracts `.data`

## Usage Examples

### Basic Usage

```ruby
sink = ActiveDataFlow::Connector::Sink::ActiveRecord.new(model: Product)
sink.write({ name: "Widget", price: 19.99 })
```

### Batch Usage

```ruby
sink = ActiveDataFlow::Connector::Sink::ActiveRecord.new(model: "Product")
sink.write_batch([
  { name: "Widget", price: 19.99 },
  { name: "Gadget", price: 29.99 }
])
```

### With Messages

```ruby
message = ActiveDataFlow::Message::Untyped.new({ name: "Widget", price: 19.99 })
sink.write(message)
```

## Error Handling

### Error Mapping

| ActiveRecord Error | Mapped To | Reason |
|-------------------|-----------|---------|
| `RecordInvalid` | `ArgumentError` | Invalid data format/validation |
| `ActiveRecordError` | `IOError` | Database/connection issues |
| `NameError` (constantize) | `ArgumentError` | Model not found |

## Performance Considerations

- Use `write_batch` for bulk operations
- `insert_all` bypasses callbacks but is faster
- Consider using `upsert_all` for idempotent writes
- Monitor database connection pool

## Testing Strategy

See: `../steering/test_driven_design.md`

- Unit tests for model resolution, data extraction, write operations
- Integration tests with real database
- Error handling tests

## Dependencies

- `active_data_flow` (core gem)
- `activerecord` (>= 6.0)

## File Structure

```
subgems/active_data_flow-connector-sink-active_record/
├── lib/
│   └── active_data_flow/
│       └── connector/
│           └── sink/
│               └── active_record.rb
├── .kiro/
│   ├── specs/
│   │   ├── requirements.md
│   │   ├── design.md (this file)
│   │   └── tasks.md
│   └── steering/ (symlinks to parent)
└── active_dataflow-connector-sink-active_record.gemspec
```
