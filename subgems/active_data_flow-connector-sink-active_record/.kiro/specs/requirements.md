# ActiveRecord Sink Connector Requirements

## Introduction

This document specifies requirements for the ActiveRecord sink connector subgem. This connector writes data from DataFlows to database tables using ActiveRecord models.

See: `../../../../.kiro/specs/requirements.md` - Requirement 3 (ActiveRecord Connector Implementation)

## Glossary

See: `../steering/glossary.md` for shared terminology

- **Sink**: A component that writes data to external systems
- **ActiveRecord**: Rails ORM for database interactions
- **Batch Write**: Writing multiple records in a single database operation

## Requirements

### Requirement 1: Basic Write Operations

**User Story:** As a developer, I want to write individual records to a database table, so that I can persist DataFlow output.

#### Acceptance Criteria

1. THE ActiveRecord Sink SHALL accept a model configuration (class, string, or symbol)
2. WHEN write is called with a Hash, THE ActiveRecord Sink SHALL create a database record
3. WHEN write is called with a Message instance, THE ActiveRecord Sink SHALL extract data and create a record
4. THE ActiveRecord Sink SHALL raise ArgumentError for invalid record formats
5. THE ActiveRecord Sink SHALL raise IOError for database errors

### Requirement 2: Batch Write Operations

**User Story:** As a developer, I want to write multiple records efficiently, so that I can optimize database performance.

#### Acceptance Criteria

1. THE ActiveRecord Sink SHALL provide a write_batch method
2. WHEN write_batch is called, THE ActiveRecord Sink SHALL use insert_all for efficiency
3. THE ActiveRecord Sink SHALL accept an array of Hashes or Messages
4. THE ActiveRecord Sink SHALL handle batch errors gracefully
5. THE ActiveRecord Sink SHALL maintain transactional integrity for batches

### Requirement 3: Model Resolution

**User Story:** As a developer, I want flexible model configuration, so that I can specify models in different ways.

#### Acceptance Criteria

1. THE ActiveRecord Sink SHALL accept model as a Class
2. THE ActiveRecord Sink SHALL accept model as a String and constantize it
3. THE ActiveRecord Sink SHALL accept model as a Symbol and constantize it
4. WHEN model cannot be resolved, THE ActiveRecord Sink SHALL raise ArgumentError
5. THE ActiveRecord Sink SHALL validate model configuration on initialization

### Requirement 4: Error Handling

**User Story:** As a developer, I want clear error messages, so that I can debug issues quickly.

#### Acceptance Criteria

1. WHEN a record is invalid, THE ActiveRecord Sink SHALL raise ArgumentError with validation details
2. WHEN a database error occurs, THE ActiveRecord Sink SHALL raise IOError with error details
3. WHEN model is not found, THE ActiveRecord Sink SHALL raise ArgumentError with model name
4. THE ActiveRecord Sink SHALL preserve original error backtraces
5. THE ActiveRecord Sink SHALL handle connection errors gracefully

### Requirement 5: Message Type Support

**User Story:** As a developer, I want to work with different message types, so that I can use typed or untyped messages.

#### Acceptance Criteria

1. THE ActiveRecord Sink SHALL accept ActiveDataFlow::Message::Untyped instances
2. THE ActiveRecord Sink SHALL accept ActiveDataFlow::Message::Typed instances
3. THE ActiveRecord Sink SHALL extract data from message instances
4. THE ActiveRecord Sink SHALL accept plain Hash objects
5. THE ActiveRecord Sink SHALL raise ArgumentError for unsupported types
