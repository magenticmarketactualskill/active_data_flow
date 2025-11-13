# ActiveDataFlow Gem Dependencies

This document details the dependency relationships between all ActiveDataFlow gems.

## Dependency Graph

```
┌─────────────────────────┐
│  active_data_flow       │  ← Core gem (no dependencies)
│  (core)                 │
└───────────┬─────────────┘
            │
            ├─────────────────────────────────────────────────────┐
            │                                                     │
            ▼                                                     ▼
┌─────────────────────────┐                         ┌─────────────────────────┐
│  source_support         │                         │  Runtime Gems           │
│  (framework extension)  │                         │                         │
└───────────┬─────────────┘                         │  • rails_heartbeat_app  │
            │                                       │  • rails_heartbeat_job  │
            │                                       │  • aws_lambda           │
            │                                       │  • flink                │
            │                                       └─────────────────────────┘
            │
            ├─────────────────────────────────────────────────────┐
            │                                                     │
            ▼                                                     ▼
┌─────────────────────────┐                         ┌─────────────────────────┐
│  Split-Based Connectors │                         │  Simple Connectors      │
│                         │                         │                         │
│  • rafka (optional)     │                         │  • active_record        │
│  • file (optional)      │                         │  • cache                │
│  • iceberg (optional)   │                         │                         │
└─────────────────────────┘                         └─────────────────────────┘
```

## Core Gem: `active_data_flow`

**Provides:**
- `ActiveDataFlow::Source` - Base source class
- `ActiveDataFlow::Sink` - Base sink class
- `ActiveDataFlow::DataFlow` - DataFlow module
- `ActiveDataFlow::Registry` - Plugin registry
- `ActiveDataFlow::Configuration` - Configuration validation
- Exception classes and logging interface

**Referenced By:**
- All subcomponent gems depend on this

**Requirements Document:** `active_data_flow/core/requirements.md`

---

## Framework Extension: `active_data_flow-source_support`

**Depends On:**
- `active_data_flow` (core)

**Provides:**
- `ActiveDataFlow::SourceSupport::Split` - Split interface
- `ActiveDataFlow::SourceSupport::Source` - Source factory
- `ActiveDataFlow::SourceSupport::SplitEnumerator` - Split coordinator
- `ActiveDataFlow::SourceSupport::SourceReader` - Split reader
- Context classes for coordination

**Referenced By:**
- `active_data_flow-rafka` (optional)
- `active_data_flow-file` (optional)
- `active_data_flow-iceberg` (optional)
- `active_data_flow-flink` (required)

**Requirements Document:** `active_data_flow/source_support/requirements.md`

---

## Runtime: `active_data_flow-rails_heartbeat_app`

**Depends On:**
- `active_data_flow` (core)

**Provides:**
- Database schema (data_flows, data_flow_runs tables)
- `DataFlow` ActiveRecord model
- `DataFlowRun` ActiveRecord model
- `DataFlowsController` with heartbeat endpoint
- Synchronous execution logic

**Referenced By:**
- `active_data_flow-rails_heartbeat_job` (extends this)

**Requirements Document:** `active_data_flow/rails_heartbeat_app/requirements.md`

---

## Runtime: `active_data_flow-rails_heartbeat_job`

**Depends On:**
- `active_data_flow` (core)
- `active_data_flow-rails_heartbeat_app` (extends)

**Provides:**
- `DataFlowRunJob` ActiveJob class
- Asynchronous execution logic
- Job enqueueing and monitoring

**Requirements Document:** `active_data_flow/rails_heartbeat_job/requirements.md`

---

## Runtime: `active_data_flow-aws_lambda`

**Depends On:**
- `active_data_flow` (core)

**Provides:**
- Lambda handler method
- Event processing (S3, SQS, EventBridge, API Gateway)
- CloudWatch logging integration
- Deployment helpers

**Requirements Document:** `active_data_flow/aws_lambda/requirements.md`

---

## Runtime: `active_data_flow-flink`

**Depends On:**
- `active_data_flow` (core)
- `active_data_flow-source_support` (required)

**Provides:**
- `FlinkJob` wrapper class
- Source/Sink integration with Flink operators
- Checkpoint and state management
- Parallelism configuration

**Requirements Document:** `active_data_flow/flink/requirements.md`

---

## Connector: `active_data_flow-rafka`

**Depends On:**
- `active_data_flow` (core)
- `active_data_flow-source_support` (optional, for split-based reading)

**Provides:**
- `ActiveDataFlow::Source::Rafka` - Stream source
- `ActiveDataFlow::Sink::Rafka` - Stream sink
- `RafkaSplit`, `RafkaSplitEnumerator`, `RafkaSourceReader` (when source_support is available)

**Requirements Document:** `active_data_flow/rafka/requirements.md`

---

## Connector: `active_data_flow-active_record`

**Depends On:**
- `active_data_flow` (core)

**Provides:**
- `ActiveDataFlow::Sink::ActiveRecord` - Database sink
- Batch insert and upsert support
- Transaction management

**Requirements Document:** `active_data_flow/active_record/requirements.md`

---

## Connector: `active_data_flow-cache`

**Depends On:**
- `active_data_flow` (core)

**Provides:**
- `ActiveDataFlow::Sink::Cache` - Cache sink
- Key generation and TTL management
- Batch write support

**Requirements Document:** `active_data_flow/cache/requirements.md`

---

## Connector: `active_data_flow-file`

**Depends On:**
- `active_data_flow` (core)
- `active_data_flow-source_support` (optional, for split-based reading)

**Provides:**
- `ActiveDataFlow::Source::File` - File source
- `ActiveDataFlow::Sink::File` - File sink
- CSV and JSON format support
- `FileSplit`, `FileSplitEnumerator`, `FileSourceReader` (when source_support is available)
- Remote file support (S3, GCS, HTTP)

**Requirements Document:** `active_data_flow/file/requirements.md`

---

## Connector: `active_data_flow-iceberg`

**Depends On:**
- `active_data_flow` (core)
- `active_data_flow-source_support` (optional, for split-based reading)

**Provides:**
- `ActiveDataFlow::Source::Iceberg` - Table source
- `ActiveDataFlow::Sink::Iceberg` - Table sink
- Snapshot and schema management
- `IcebergSplit`, `IcebergSplitEnumerator` (when source_support is available)
- Catalog integration (Hive, Glue, REST)

**Requirements Document:** `active_data_flow/iceberg/requirements.md`

---

## Installation Scenarios

### Scenario 1: Simple Rails Application
```ruby
# Gemfile
gem 'active_data_flow'
gem 'active_data_flow-rails_heartbeat_app'
gem 'active_data_flow-file'
gem 'active_data_flow-active_record'
```

### Scenario 2: High-Throughput Streaming
```ruby
# Gemfile
gem 'active_data_flow'
gem 'active_data_flow-source_support'
gem 'active_data_flow-rails_heartbeat_job'
gem 'active_data_flow-rafka'
gem 'active_data_flow-active_record'
```

### Scenario 3: Serverless Processing
```ruby
# Gemfile
gem 'active_data_flow'
gem 'active_data_flow-aws_lambda'
gem 'active_data_flow-file'
gem 'active_data_flow-cache'
```

### Scenario 4: Distributed Analytics
```ruby
# Gemfile
gem 'active_data_flow'
gem 'active_data_flow-source_support'
gem 'active_data_flow-flink'
gem 'active_data_flow-iceberg'
```

## Version Compatibility

All subcomponent gems must specify compatible core version:

```ruby
# In gemspec
spec.add_dependency 'active_data_flow', '~> 1.0'
```

The core gem validates subcomponent compatibility on load.
