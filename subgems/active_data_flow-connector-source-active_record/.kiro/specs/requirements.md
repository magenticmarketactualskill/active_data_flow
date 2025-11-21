# ActiveRecord Source Connector Requirements

## Introduction

This document specifies requirements for the ActiveRecord source connector subgem. This connector reads data from database tables using ActiveRecord models and yields records for DataFlow processing.

See: `../../../../.kiro/specs/requirements.md` - Requirement 3 (ActiveRecord Connector Implementation)

## Glossary

See: `../steering/glossary.md` for shared terminology

- **Source**: A component that reads data from external systems
- **ActiveRecord**: Rails ORM for database interactions
- **Batch Loading**: Reading records in chunks to manage memory
- **Scope**: ActiveRecord query constraints (where, order, etc.)

## Requirements

### Requirement 1: Basic Read Operations

**User Story:** As a developer, I want to read records from a database table, so that I can process them in a DataFlow.

#### Acceptance Criteria

1. THE ActiveRecord Source SHALL accept a model configuration (class, string, or symbol)
2. THE ActiveRecord Source SHALL provide an `each` method that yields records
3. WHEN each is called, THE ActiveRecord Source SHALL return Message instances
4. THE ActiveRecord Source SHALL wrap records with metadata (model name, ID)
5. THE ActiveRecord Source SHALL raise IOError for database errors

### Requirement 2: Memory-Efficient Batching

**User Story:** As a developer, I want to process large datasets without loading all records into memory, so that my application remains performant.

#### Acceptance Criteria

1. THE ActiveRecord Source SHALL use `find_each` for batched loading
2. THE ActiveRecord Source SHALL accept a configurable batch_size parameter
3. WHEN batch_size is not specified, THE ActiveRecord Source SHALL default to 1000
4. THE ActiveRecord Source SHALL load records in batches to manage memory
5. THE ActiveRecord Source SHALL maintain iteration order within batches

### Requirement 3: Custom Scopes

**User Story:** As a developer, I want to filter and order records, so that I can process only relevant data.

#### Acceptance Criteria

1. THE ActiveRecord Source SHALL accept an optional scope configuration
2. WHEN scope is provided as a Proc, THE ActiveRecord Source SHALL apply it to the relation
3. THE ActiveRecord Source SHALL support any valid ActiveRecord query methods in scope
4. WHEN scope is not provided, THE ActiveRecord Source SHALL read all records
5. THE ActiveRecord Source SHALL preserve scope constraints during iteration

### Requirement 4: Model Resolution

**User Story:** As a developer, I want flexible model configuration, so that I can specify models in different ways.

#### Acceptance Criteria

1. THE ActiveRecord Source SHALL accept model as a Class
2. THE ActiveRecord Source SHALL accept model as a String and constantize it
3. THE ActiveRecord Source SHALL accept model as a Symbol and constantize it
4. WHEN model cannot be resolved, THE ActiveRecord Source SHALL raise ArgumentError
5. THE ActiveRecord Source SHALL validate model configuration on initialization

### Requirement 5: Record Counting

**User Story:** As a developer, I want to know how many records will be processed, so that I can monitor progress.

#### Acceptance Criteria

1. THE ActiveRecord Source SHALL provide a `count` method
2. WHEN count is called, THE ActiveRecord Source SHALL return the total number of records
3. THE ActiveRecord Source SHALL respect scope constraints when counting
4. THE ActiveRecord Source SHALL raise IOError for database errors during count
5. THE ActiveRecord Source SHALL use efficient SQL COUNT queries

### Requirement 6: Message Wrapping

**User Story:** As a developer, I want records wrapped as Message instances, so that they work seamlessly with DataFlow components.

#### Acceptance Criteria

1. THE ActiveRecord Source SHALL return ActiveDataFlow::Message::Untyped instances
2. WHEN wrapping a record, THE ActiveRecord Source SHALL convert attributes to a Hash
3. THE ActiveRecord Source SHALL include model name in message metadata
4. THE ActiveRecord Source SHALL include record ID in message metadata
5. THE ActiveRecord Source SHALL preserve all record attributes in message data
