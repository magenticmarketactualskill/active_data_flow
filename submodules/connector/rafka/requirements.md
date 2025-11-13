# ActiveDataFlow Rafka - Requirements Document

## Introduction

This document specifies the requirements for the `active_data_flow-rafka` gem, which provides Source and Sink implementations for Rafka (Kafka-compatible API backed by Redis streams).

**Dependencies:**
- `active_data_flow` (core) - Provides Source and Sink base classes
- `active_data_flow-source_support` (optional) - Enables split-based parallel reading

This connector gem extends the core `active_data_flow` gem with Rafka streaming capabilities, supporting both simple source/sink patterns and advanced split-based parallel processing.

## Glossary

- **Rafka**: A Kafka-compatible API backed by Redis streams
- **Stream**: A Redis stream that holds messages
- **Consumer Group**: A group of consumers that share message processing
- **Partition**: A logical division of a stream for parallel processing

## Requirements

### Requirement 1: Rafka Source

**User Story:** As a developer, I want a Rafka source, so that I can read messages from Redis streams.

#### Acceptance Criteria

1. THE Rafka gem SHALL provide an ActiveDataFlow::Source::Rafka class
2. THE Rafka source SHALL accept stream_name, consumer_group, and consumer_name configuration
3. THE Rafka source SHALL implement the each method to yield messages
4. THE Rafka source SHALL connect to Redis using the Rafka client library
5. THE Rafka source SHALL handle connection errors gracefully

### Requirement 2: Message Reading

**User Story:** As a developer, I want reliable message reading, so that no messages are lost during processing.

#### Acceptance Criteria

1. WHEN reading messages, THE Rafka source SHALL fetch batches from the stream
2. THE Rafka source SHALL support configurable batch sizes
3. THE Rafka source SHALL acknowledge messages after successful processing
4. THE Rafka source SHALL support consumer group semantics
5. THE Rafka source SHALL handle message deserialization

### Requirement 3: Rafka Sink

**User Story:** As a developer, I want a Rafka sink, so that I can write messages to Redis streams.

#### Acceptance Criteria

1. THE Rafka gem SHALL provide an ActiveDataFlow::Sink::Rafka class
2. THE Rafka sink SHALL accept stream_name configuration
3. THE Rafka sink SHALL implement the write method to publish messages
4. THE Rafka sink SHALL serialize messages before publishing
5. THE Rafka sink SHALL handle write errors with retries

### Requirement 4: Split-Based Rafka Source

**User Story:** As a developer, I want split-based Rafka reading, so that I can process partitions in parallel.

#### Acceptance Criteria

1. THE Rafka gem SHALL provide an ActiveDataFlow::SourceSupport::Rafka::RafkaSplit class
2. THE RafkaSplit SHALL represent a single stream partition
3. THE RafkaSplit SHALL include stream_name and partition_id
4. THE RafkaSplit SHALL implement the split_id method
5. THE RafkaSplit SHALL be serializable

### Requirement 5: Rafka Split Enumerator

**User Story:** As a developer, I want automatic partition discovery, so that all partitions are processed.

#### Acceptance Criteria

1. THE Rafka gem SHALL provide a RafkaSplitEnumerator class
2. THE RafkaSplitEnumerator SHALL discover partitions on start
3. THE RafkaSplitEnumerator SHALL assign partitions to readers on request
4. THE RafkaSplitEnumerator SHALL handle partition rebalancing
5. THE RafkaSplitEnumerator SHALL track assigned partitions

### Requirement 6: Rafka Source Reader

**User Story:** As a developer, I want parallel partition reading, so that I can achieve high throughput.

#### Acceptance Criteria

1. THE Rafka gem SHALL provide a RafkaSourceReader class
2. THE RafkaSourceReader SHALL accept partition assignments
3. THE RafkaSourceReader SHALL read from assigned partitions in poll method
4. THE RafkaSourceReader SHALL maintain partition offsets
5. THE RafkaSourceReader SHALL handle partition reassignment

### Requirement 7: Configuration

**User Story:** As a developer, I want flexible Rafka configuration, so that I can customize connection settings.

#### Acceptance Criteria

1. THE Rafka gem SHALL support Redis connection URL configuration
2. THE Rafka gem SHALL support authentication credentials
3. THE Rafka gem SHALL support connection pool settings
4. THE Rafka gem SHALL support timeout configuration
5. THE Rafka gem SHALL validate configuration on initialization
