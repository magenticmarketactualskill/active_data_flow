# ActiveDataFlow Source Support - Requirements Document

## Introduction

This document specifies the requirements for the `active_data_flow-source_support` gem, which implements Flink-inspired split-based source architecture for parallel data ingestion.

**Dependencies:**
- `active_data_flow` (core) - Provides base Source class and plugin registry

This gem extends the core `active_data_flow` gem with split-based source capabilities, enabling parallel data ingestion with work distribution across multiple readers.

## Glossary

- **Split**: A portion of a data source that can be processed independently
- **SplitEnumerator**: A coordinator that discovers splits and assigns them to readers
- **SourceReader**: A worker that reads data from assigned splits
- **Boundedness**: Whether a source is bounded (batch) or unbounded (streaming)

## Requirements

### Requirement 1: Split Interface

**User Story:** As a connector developer, I want a Split interface, so that I can represent units of work for parallel processing.

#### Acceptance Criteria

1. THE SourceSupport SHALL provide an ActiveDataFlow::SourceSupport::Split module
2. THE Split SHALL define a `split_id` method that returns a unique identifier
3. THE Split SHALL be serializable for distribution across workers
4. THE Split SHALL support custom attributes for implementation-specific data
5. THE Split SHALL raise NotImplementedError if split_id is not implemented

### Requirement 2: Source Factory Class

**User Story:** As a developer, I want a Source factory, so that I can create enumerators and readers for split-based processing.

#### Acceptance Criteria

1. THE SourceSupport SHALL provide an ActiveDataFlow::SourceSupport::Source class
2. THE Source SHALL define a `create_enumerator(context)` factory method
3. THE Source SHALL define a `create_reader(context)` factory method
4. THE Source SHALL define a `boundedness` method returning :bounded or :unbounded
5. THE Source SHALL define a `split_serializer` method for split serialization

### Requirement 3: SplitEnumerator Base Class

**User Story:** As a connector developer, I want a SplitEnumerator base class, so that I can implement split discovery and assignment logic.

#### Acceptance Criteria

1. THE SourceSupport SHALL provide an ActiveDataFlow::SourceSupport::SplitEnumerator class
2. THE SplitEnumerator SHALL define a `start` method for initialization
3. THE SplitEnumerator SHALL define an `add_reader(reader_id)` method for reader registration
4. THE SplitEnumerator SHALL define a `handle_split_request(reader_id)` method for assignment
5. THE SplitEnumerator SHALL define an `add_splits_back(splits)` method for failure recovery

### Requirement 4: SourceReader Base Class

**User Story:** As a connector developer, I want a SourceReader base class, so that I can implement parallel data reading from splits.

#### Acceptance Criteria

1. THE SourceSupport SHALL provide an ActiveDataFlow::SourceSupport::SourceReader class
2. THE SourceReader SHALL define a `start` method for initialization
3. THE SourceReader SHALL define a `poll` method that returns records non-blocking
4. THE SourceReader SHALL define an `add_splits(splits)` method for split assignment
5. THE SourceReader SHALL define a `close` method for cleanup

### Requirement 5: SplitEnumeratorContext

**User Story:** As a connector developer, I want an enumerator context, so that I can communicate with readers.

#### Acceptance Criteria

1. THE SourceSupport SHALL provide an ActiveDataFlow::SourceSupport::SplitEnumeratorContext class
2. THE SplitEnumeratorContext SHALL provide an `assign_split(split, reader_id)` method
3. THE SplitEnumeratorContext SHALL provide a `current_parallelism` method
4. THE SplitEnumeratorContext SHALL provide a `signal_no_more_splits(reader_id)` method
5. THE SplitEnumeratorContext SHALL handle communication with distributed readers

### Requirement 6: SourceReaderContext

**User Story:** As a connector developer, I want a reader context, so that I can request splits from the enumerator.

#### Acceptance Criteria

1. THE SourceSupport SHALL provide an ActiveDataFlow::SourceSupport::SourceReaderContext class
2. THE SourceReaderContext SHALL provide a `send_split_request` method
3. THE SourceReaderContext SHALL provide access to reader configuration
4. THE SourceReaderContext SHALL provide access to reader metrics
5. THE SourceReaderContext SHALL handle communication with the enumerator
