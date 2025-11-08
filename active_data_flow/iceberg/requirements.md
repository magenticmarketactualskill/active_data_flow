# ActiveDataFlow Iceberg - Requirements Document

## Introduction

This document specifies the requirements for the `active_data_flow-iceberg` gem, which provides Source and Sink implementations for Apache Iceberg table format.

## Glossary

- **Iceberg**: Apache Iceberg open table format for large analytic datasets
- **Table**: An Iceberg table with schema and data files
- **Snapshot**: A point-in-time view of an Iceberg table
- **Manifest**: Metadata file listing data files in a snapshot

## Requirements

### Requirement 1: Iceberg Source

**User Story:** As a developer, I want an Iceberg source, so that I can read data from Iceberg tables.

#### Acceptance Criteria

1. THE Iceberg gem SHALL provide an ActiveDataFlow::Source::Iceberg class
2. THE Iceberg source SHALL accept table_name and catalog configuration
3. THE Iceberg source SHALL implement the each method to yield records
4. THE Iceberg source SHALL connect to Iceberg catalog (Hive, Glue, REST)
5. THE Iceberg source SHALL read from the latest snapshot by default

### Requirement 2: Snapshot Reading

**User Story:** As a developer, I want snapshot-based reading, so that I can read consistent table views.

#### Acceptance Criteria

1. THE Iceberg source SHALL support snapshot_id configuration
2. THE Iceberg source SHALL support as_of_timestamp configuration
3. THE Iceberg source SHALL read data files from the specified snapshot
4. THE Iceberg source SHALL handle schema evolution
5. THE Iceberg source SHALL support incremental reads between snapshots

### Requirement 3: Iceberg Sink

**User Story:** As a developer, I want an Iceberg sink, so that I can write data to Iceberg tables.

#### Acceptance Criteria

1. THE Iceberg gem SHALL provide an ActiveDataFlow::Sink::Iceberg class
2. THE Iceberg sink SHALL accept table_name and catalog configuration
3. THE Iceberg sink SHALL implement the write method to append records
4. THE Iceberg sink SHALL create new data files in Parquet format
5. THE Iceberg sink SHALL commit data files to create new snapshots

### Requirement 4: Schema Management

**User Story:** As a developer, I want automatic schema handling, so that schema evolution is managed correctly.

#### Acceptance Criteria

1. THE Iceberg sink SHALL read the current table schema
2. THE Iceberg sink SHALL validate records match the schema
3. THE Iceberg sink SHALL support schema evolution (add columns)
4. THE Iceberg sink SHALL handle type promotions
5. THE Iceberg sink SHALL reject incompatible schema changes

### Requirement 5: Partitioning Support

**User Story:** As a developer, I want partition-aware writes, so that data is organized efficiently.

#### Acceptance Criteria

1. THE Iceberg sink SHALL read the table's partition spec
2. THE Iceberg sink SHALL partition records according to the spec
3. THE Iceberg sink SHALL write data files to correct partition paths
4. THE Iceberg sink SHALL support hidden partitioning
5. THE Iceberg sink SHALL handle partition evolution

### Requirement 6: Split-Based Iceberg Source

**User Story:** As a developer, I want split-based Iceberg reading, so that I can process tables in parallel.

#### Acceptance Criteria

1. THE Iceberg gem SHALL provide an IcebergSplit class
2. THE IcebergSplit SHALL represent a set of data files
3. THE IcebergSplit SHALL include file paths and row ranges
4. THE IcebergSplit SHALL implement the split_id method
5. THE IcebergSplit SHALL be serializable

### Requirement 7: Iceberg Split Enumerator

**User Story:** As a developer, I want automatic split planning, so that work is distributed efficiently.

#### Acceptance Criteria

1. THE Iceberg gem SHALL provide an IcebergSplitEnumerator class
2. THE IcebergSplitEnumerator SHALL read manifest files on start
3. THE IcebergSplitEnumerator SHALL create splits from data files
4. THE IcebergSplitEnumerator SHALL support target split size configuration
5. THE IcebergSplitEnumerator SHALL assign splits to readers on request

### Requirement 8: Catalog Integration

**User Story:** As a developer, I want catalog integration, so that I can discover and manage tables.

#### Acceptance Criteria

1. THE Iceberg gem SHALL support Hive Metastore catalog
2. THE Iceberg gem SHALL support AWS Glue catalog
3. THE Iceberg gem SHALL support REST catalog
4. THE Iceberg gem SHALL support Hadoop catalog
5. THE Iceberg gem SHALL handle catalog authentication
