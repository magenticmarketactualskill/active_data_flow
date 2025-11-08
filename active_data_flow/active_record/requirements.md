# ActiveDataFlow ActiveRecord - Requirements Document

## Introduction

This document specifies the requirements for the `active_data_flow-active_record` gem, which provides Sink implementation for writing data to Rails database tables using ActiveRecord.

**Dependencies:**
- `active_data_flow` (core) - Provides Sink base class

This connector gem extends the core `active_data_flow` gem with database writing capabilities, leveraging Rails ActiveRecord for ORM functionality.

## Glossary

- **ActiveRecord**: Rails ORM for database access
- **Model**: An ActiveRecord model class representing a database table
- **Batch Insert**: Inserting multiple records in a single database transaction

## Requirements

### Requirement 1: ActiveRecord Sink

**User Story:** As a developer, I want an ActiveRecord sink, so that I can write processed data to database tables.

#### Acceptance Criteria

1. THE ActiveRecord gem SHALL provide an ActiveDataFlow::Sink::ActiveRecord class
2. THE ActiveRecord sink SHALL accept model_name configuration
3. THE ActiveRecord sink SHALL implement the write method to create records
4. THE ActiveRecord sink SHALL resolve model_name to the ActiveRecord class
5. THE ActiveRecord sink SHALL handle validation errors gracefully

### Requirement 2: Record Creation

**User Story:** As a developer, I want reliable record creation, so that data is persisted correctly.

#### Acceptance Criteria

1. WHEN writing a record, THE ActiveRecord sink SHALL call create! on the model
2. THE ActiveRecord sink SHALL pass record attributes to create!
3. THE ActiveRecord sink SHALL handle unique constraint violations
4. THE ActiveRecord sink SHALL log validation errors
5. THE ActiveRecord sink SHALL support custom error handling callbacks

### Requirement 3: Batch Writing

**User Story:** As a developer, I want batch inserts, so that I can achieve high write throughput.

#### Acceptance Criteria

1. THE ActiveRecord sink SHALL support batch_size configuration
2. WHEN batch_size is set, THE ActiveRecord sink SHALL buffer records
3. THE ActiveRecord sink SHALL use insert_all for batch inserts
4. THE ActiveRecord sink SHALL flush batches when buffer is full
5. THE ActiveRecord sink SHALL provide a flush method for manual flushing

### Requirement 4: Upsert Support

**User Story:** As a developer, I want upsert capability, so that I can update existing records.

#### Acceptance Criteria

1. THE ActiveRecord sink SHALL support upsert mode configuration
2. WHEN upsert is enabled, THE ActiveRecord sink SHALL use upsert_all
3. THE ActiveRecord sink SHALL accept unique_by configuration for conflict detection
4. THE ActiveRecord sink SHALL support update_only configuration for selective updates
5. THE ActiveRecord sink SHALL handle upsert conflicts gracefully

### Requirement 5: Transaction Management

**User Story:** As a developer, I want transaction control, so that I can ensure data consistency.

#### Acceptance Criteria

1. THE ActiveRecord sink SHALL support transaction mode configuration
2. WHEN transaction mode is enabled, THE ActiveRecord sink SHALL wrap writes in transactions
3. THE ActiveRecord sink SHALL support configurable transaction batch size
4. THE ActiveRecord sink SHALL rollback transactions on errors
5. THE ActiveRecord sink SHALL commit transactions on successful batch completion

### Requirement 6: Connection Management

**User Story:** As a developer, I want proper connection handling, so that database connections are managed efficiently.

#### Acceptance Criteria

1. THE ActiveRecord sink SHALL use Rails connection pool
2. THE ActiveRecord sink SHALL release connections after writes
3. THE ActiveRecord sink SHALL handle connection timeouts
4. THE ActiveRecord sink SHALL support multiple database configurations
5. THE ActiveRecord sink SHALL validate database connectivity on initialization

### Requirement 7: Performance Optimization

**User Story:** As a developer, I want optimized writes, so that I can achieve maximum throughput.

#### Acceptance Criteria

1. THE ActiveRecord sink SHALL support disabling callbacks for bulk inserts
2. THE ActiveRecord sink SHALL support disabling validations for trusted data
3. THE ActiveRecord sink SHALL use prepared statements when possible
4. THE ActiveRecord sink SHALL support connection-specific optimizations
5. THE ActiveRecord sink SHALL provide metrics for write performance
