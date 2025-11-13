# ActiveDataFlow Gem Suite Structure

## Directory Structure

```
active_data_flow/
├── README.md                                    # Overview and usage guide
├── STRUCTURE.md                                 # This file
│
├── core/
│   └── requirements.md                          # Core gem requirements
│
├── source_support/
│   └── requirements.md                          # Split-based source framework
│
├── Runtime Implementations/
│   ├── rails_heartbeat_app/
│   │   └── requirements.md                      # Synchronous Rails execution
│   ├── rails_heartbeat_job/
│   │   └── requirements.md                      # ActiveJob execution
│   ├── aws_lambda/
│   │   └── requirements.md                      # AWS Lambda execution
│   └── flink/
│       └── requirements.md                      # Apache Flink execution
│
└── Connector Implementations/
    ├── rafka/
    │   └── requirements.md                      # Kafka-compatible Redis streams
    ├── active_record/
    │   └── requirements.md                      # Rails database sink
    ├── cache/
    │   └── requirements.md                      # Rails cache sink
    ├── file/
    │   └── requirements.md                      # File source/sink
    └── iceberg/
        └── requirements.md                      # Apache Iceberg source/sink
```

## Gem Breakdown

### 1. Core Gem: `active_data_flow`
**Purpose**: Provides abstract interfaces and base classes

**Key Components**:
- `ActiveDataFlow::Source` - Base source class
- `ActiveDataFlow::Sink` - Base sink class
- `ActiveDataFlow::DataFlow` - DataFlow module
- `ActiveDataFlow::Registry` - Plugin registry
- `ActiveDataFlow::Configuration` - Configuration validation
- Custom exception classes
- Logging interface

**Requirements**: 8 requirements covering interfaces, plugin system, validation, and error handling

---

### 2. Framework Extension: `active_data_flow-source_support`
**Purpose**: Flink-inspired split-based source architecture

**Key Components**:
- `ActiveDataFlow::SourceSupport::Split` - Split interface
- `ActiveDataFlow::SourceSupport::Source` - Source factory
- `ActiveDataFlow::SourceSupport::SplitEnumerator` - Split coordinator
- `ActiveDataFlow::SourceSupport::SourceReader` - Split reader
- Context classes for coordination

**Requirements**: 6 requirements covering split enumeration and parallel reading

---

### 3. Runtime: `active_data_flow-rails_heartbeat_app`
**Purpose**: Synchronous DataFlow execution in Rails app process

**Key Components**:
- Database migrations (data_flows, data_flow_runs tables)
- `DataFlow` ActiveRecord model
- `DataFlowRun` ActiveRecord model
- `DataFlowsController` with heartbeat endpoint
- Synchronous execution logic

**Requirements**: 7 requirements covering database schema, models, controller, and security

---

### 4. Runtime: `active_data_flow-rails_heartbeat_job`
**Purpose**: Asynchronous DataFlow execution via ActiveJob

**Key Components**:
- `DataFlowRunJob` ActiveJob class
- Job enqueueing logic
- Execution logging
- Error handling and retries

**Requirements**: 6 requirements covering async execution, logging, and monitoring

---

### 5. Runtime: `active_data_flow-aws_lambda`
**Purpose**: Serverless DataFlow execution on AWS Lambda

**Key Components**:
- Lambda handler method
- Event processing for S3, SQS, EventBridge, API Gateway
- Configuration from environment, Parameter Store, Secrets Manager
- CloudWatch logging integration
- Deployment helpers

**Requirements**: 7 requirements covering Lambda execution, events, and deployment

---

### 6. Runtime: `active_data_flow-flink`
**Purpose**: Distributed DataFlow execution on Apache Flink

**Key Components**:
- `FlinkJob` wrapper class
- Source/Sink integration with Flink operators
- Checkpoint integration
- State management
- Parallelism configuration
- Monitoring integration

**Requirements**: 8 requirements covering Flink integration and deployment

---

### 7. Connector: `active_data_flow-rafka`
**Purpose**: Kafka-compatible source/sink backed by Redis streams

**Key Components**:
- `ActiveDataFlow::Source::Rafka` - Stream source
- `ActiveDataFlow::Sink::Rafka` - Stream sink
- `RafkaSplit` - Partition split
- `RafkaSplitEnumerator` - Partition discovery
- `RafkaSourceReader` - Partition reader

**Requirements**: 7 requirements covering streaming, partitions, and configuration

---

### 8. Connector: `active_data_flow-active_record`
**Purpose**: Sink for writing to Rails database tables

**Key Components**:
- `ActiveDataFlow::Sink::ActiveRecord` - Database sink
- Batch insert support
- Upsert support
- Transaction management
- Connection pooling

**Requirements**: 7 requirements covering writes, batching, upserts, and performance

---

### 9. Connector: `active_data_flow-cache`
**Purpose**: Sink for writing to Rails cache

**Key Components**:
- `ActiveDataFlow::Sink::Cache` - Cache sink
- Key generation
- Value serialization
- TTL management
- Batch writes

**Requirements**: 7 requirements covering caching, serialization, and TTL

---

### 10. Connector: `active_data_flow-file`
**Purpose**: Source/Sink for file operations

**Key Components**:
- `ActiveDataFlow::Source::File` - File source
- `ActiveDataFlow::Sink::File` - File sink
- CSV and JSON format support
- `FileSplit` - File split
- `FileSplitEnumerator` - File discovery
- `FileSourceReader` - File reader
- Remote file support (S3, GCS, HTTP)

**Requirements**: 8 requirements covering formats, splits, and remote access

---

### 11. Connector: `active_data_flow-iceberg`
**Purpose**: Source/Sink for Apache Iceberg tables

**Key Components**:
- `ActiveDataFlow::Source::Iceberg` - Table source
- `ActiveDataFlow::Sink::Iceberg` - Table sink
- Snapshot reading
- Schema management
- Partitioning support
- `IcebergSplit` - Data file split
- `IcebergSplitEnumerator` - Split planning
- Catalog integration (Hive, Glue, REST)

**Requirements**: 8 requirements covering tables, snapshots, and catalogs

---

## Total Requirements Count

| Gem | Requirements |
|-----|--------------|
| core | 8 |
| source_support | 6 |
| rails_heartbeat_app | 7 |
| rails_heartbeat_job | 6 |
| aws_lambda | 7 |
| flink | 8 |
| rafka | 7 |
| active_record | 7 |
| cache | 7 |
| file | 8 |
| iceberg | 8 |
| **TOTAL** | **79** |

## Development Priority

Recommended implementation order:

1. **Phase 1 - Foundation**
   - `active_data_flow` (core)
   - `active_data_flow-source_support`

2. **Phase 2 - Basic Runtime**
   - `active_data_flow-rails_heartbeat_app`

3. **Phase 3 - Basic Connectors**
   - `active_data_flow-file`
   - `active_data_flow-active_record`

4. **Phase 4 - Advanced Runtime**
   - `active_data_flow-rails_heartbeat_job`

5. **Phase 5 - Streaming Connectors**
   - `active_data_flow-rafka`
   - `active_data_flow-cache`

6. **Phase 6 - Cloud Runtimes**
   - `active_data_flow-aws_lambda`

7. **Phase 7 - Advanced Connectors**
   - `active_data_flow-iceberg`

8. **Phase 8 - Distributed Runtime**
   - `active_data_flow-flink`
