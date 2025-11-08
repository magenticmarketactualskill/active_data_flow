# ActiveDataFlow - Modular Ruby Gem Suite

This directory contains the specifications for the ActiveDataFlow gem suite, a modular stream processing framework for Ruby inspired by Apache Flink.

## Architecture Overview

ActiveDataFlow follows a plugin-based architecture where the core gem provides abstract interfaces, and separate gems provide concrete implementations.

```
active_data_flow (core)
├── Runtime Implementations
│   ├── rails_heartbeat_app
│   ├── rails_heartbeat_job
│   ├── aws_lambda
│   └── flink
├── Connector Implementations
│   ├── rafka
│   ├── active_record
│   ├── cache
│   ├── file
│   └── iceberg
└── Framework Extensions
    └── source_support
```

## Gem Structure

### Core Gem
- **`active_data_flow`** - Abstract interfaces and base classes
  - Provides: Source, Sink, DataFlow, Registry, Configuration
  - No concrete implementations
  - All other gems depend on this

### Runtime Gems
Runtime gems provide execution environments for DataFlows:

- **`active_data_flow-rails_heartbeat_app`** - Synchronous execution in Rails app process
- **`active_data_flow-rails_heartbeat_job`** - Asynchronous execution via ActiveJob
- **`active_data_flow-aws_lambda`** - Serverless execution on AWS Lambda
- **`active_data_flow-flink`** - Distributed execution on Apache Flink

### Connector Gems
Connector gems provide Source and Sink implementations:

- **`active_data_flow-rafka`** - Kafka-compatible Redis streams
- **`active_data_flow-active_record`** - Rails database tables
- **`active_data_flow-cache`** - Rails cache (Redis, Memcached)
- **`active_data_flow-file`** - Local and remote files (CSV, JSON)
- **`active_data_flow-iceberg`** - Apache Iceberg tables

### Framework Extensions
- **`active_data_flow-source_support`** - Flink-inspired split-based sources

## Requirements Documents

Each gem has its own `requirements.md` file specifying:
- User stories with acceptance criteria in EARS format
- Glossary of domain terms
- Detailed functional requirements

## Development Workflow

1. **Core Development**: Start with the core gem to establish interfaces
2. **Runtime Development**: Implement one runtime (e.g., rails_heartbeat_app)
3. **Connector Development**: Implement connectors as needed
4. **Integration Testing**: Test combinations of runtimes and connectors

## Dependencies

```
active_data_flow (core)
├── active_data_flow-source_support
│   ├── active_data_flow-rafka (split-based)
│   ├── active_data_flow-file (split-based)
│   ├── active_data_flow-iceberg (split-based)
│   └── active_data_flow-flink (uses splits)
│
├── Runtime Gems
│   ├── active_data_flow-rails_heartbeat_app
│   │   └── active_data_flow-rails_heartbeat_job (extends app)
│   ├── active_data_flow-aws_lambda
│   └── active_data_flow-flink
│
└── Connector Gems
    ├── active_data_flow-rafka
    ├── active_data_flow-active_record
    ├── active_data_flow-cache
    ├── active_data_flow-file
    └── active_data_flow-iceberg

Application
└── Depends on: core + runtime + connectors
```

### Dependency Matrix

| Gem | Depends On |
|-----|------------|
| `active_data_flow` | (none) |
| `active_data_flow-source_support` | core |
| `active_data_flow-rails_heartbeat_app` | core |
| `active_data_flow-rails_heartbeat_job` | core, rails_heartbeat_app |
| `active_data_flow-aws_lambda` | core |
| `active_data_flow-flink` | core, source_support |
| `active_data_flow-rafka` | core, source_support (optional) |
| `active_data_flow-active_record` | core |
| `active_data_flow-cache` | core |
| `active_data_flow-file` | core, source_support (optional) |
| `active_data_flow-iceberg` | core, source_support (optional) |

## Example Usage

```ruby
# Gemfile
gem 'active_data_flow'
gem 'active_data_flow-rails_heartbeat_job'
gem 'active_data_flow-rafka'
gem 'active_data_flow-active_record'

# app/data_flows/product_update_flow.rb
class ProductUpdateFlow
  include ActiveDataFlow::DataFlow

  def run
    source = ActiveDataFlow::Source.create(:rafka, configuration[:source])
    sink = ActiveDataFlow::Sink.create(:active_record, configuration[:sink])

    source.each do |message|
      transformed = transform(message)
      sink.write(transformed)
    end
  end

  private

  def transform(message)
    message.merge(processed_at: Time.current)
  end
end
```

## Next Steps

1. Review requirements for each gem
2. Create design documents for each gem
3. Create implementation task lists
4. Begin development with core gem
