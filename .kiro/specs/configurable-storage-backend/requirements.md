# Requirements Document

## Introduction

This document specifies the requirements for adding configurable storage backend support to the `active_data_flow` gem. Currently, the gem hardcodes ActiveRecord as the storage layer for DataFlow and DataFlowRun models. This feature will allow users to configure alternative storage backends, specifically supporting Redcord/Redis as an alternative to ActiveRecord/SQL databases.

The goal is to enable applications like `rails8-redcord` to use Redis (via redis-emulator and redcord) as the persistence layer while maintaining backward compatibility with existing ActiveRecord-based installations.

## Glossary

See: `.kiro/glossary.md` for complete term definitions.

Key terms for this spec:
- **Storage Backend**: The persistence layer for DataFlow and DataFlowRun records
- **ActiveRecord Backend** (`:active_record`): SQL database storage (default)
- **Redcord Redis Backend** (`:redcord_redis`): Redis-based storage using standard Redis server
- **Redcord Redis Emulator Backend** (`:redcord_redis_emulator`): Redis-compatible storage backed by Rails Solid Cache

## Requirements

### Requirement 1: Storage Backend Configuration

**User Story:** As a Rails developer, I want to configure which storage backend ActiveDataFlow uses, so that I can choose between ActiveRecord and Redcord based on my application's needs.

#### Acceptance Criteria

1. THE ActiveDataFlow SHALL provide a configuration option `storage_backend` that accepts `:active_record`, `:redcord_redis`, or `:redcord_redis_emulator`
2. WHEN no storage backend is configured, THE ActiveDataFlow SHALL default to `:active_record`
3. WHEN a storage backend is configured, THE ActiveDataFlow SHALL load the appropriate model implementations
4. THE ActiveDataFlow SHALL validate that the configured storage backend is supported
5. THE ActiveDataFlow SHALL raise a clear error message if an unsupported storage backend is specified

### Requirement 2: ActiveRecord Backend Support

**User Story:** As a Rails developer using SQL databases, I want ActiveRecord to remain the default storage backend, so that existing applications continue to work without configuration changes.

#### Acceptance Criteria

1. WHEN storage_backend is `:active_record` or unspecified, THE ActiveDataFlow SHALL use ActiveRecord-based models
2. THE ActiveDataFlow SHALL load DataFlow and DataFlowRun models that inherit from ApplicationRecord
3. THE ActiveDataFlow SHALL use standard Rails migrations for database schema
4. THE ActiveDataFlow SHALL support all ActiveRecord associations (has_many, belongs_to)
5. THE ActiveDataFlow SHALL maintain backward compatibility with existing ActiveRecord-based installations

### Requirement 3: Redcord Redis Backend Support

**User Story:** As a Rails developer using Redis, I want to configure ActiveDataFlow to use Redcord with a standard Redis server for storage, so that I can leverage Redis performance and avoid SQL database dependencies.

#### Acceptance Criteria

1. WHEN storage_backend is `:redcord_redis`, THE ActiveDataFlow SHALL use Redcord-based models
2. THE ActiveDataFlow SHALL load DataFlow and DataFlowRun models that include Redcord::Base
3. THE ActiveDataFlow SHALL define Redis schema using Redcord's DSL (range_index, attribute)
4. THE ActiveDataFlow SHALL support Redcord associations and queries
5. THE ActiveDataFlow SHALL connect to a standard Redis server

### Requirement 3a: Redcord Redis Emulator Backend Support

**User Story:** As a Rails developer using Rails Solid Cache, I want to configure ActiveDataFlow to use Redcord with redis-emulator for storage, so that I can use Redis-like storage without running a separate Redis server.

#### Acceptance Criteria

1. WHEN storage_backend is `:redcord_redis_emulator`, THE ActiveDataFlow SHALL use Redcord-based models with redis-emulator
2. THE ActiveDataFlow SHALL configure Redcord to use Redis::Emulator as the Redis client
3. THE ActiveDataFlow SHALL use Rails.cache (Solid Cache) as the backing store for redis-emulator
4. THE ActiveDataFlow SHALL not require a separate Redis server when using redis-emulator
5. THE ActiveDataFlow SHALL provide the same Redcord model interface as the standard Redcord Redis backend

### Requirement 4: Model Interface Consistency

**User Story:** As a developer maintaining ActiveDataFlow, I want both storage backends to provide the same model interface, so that the rest of the codebase works regardless of the storage choice.

#### Acceptance Criteria

1. THE ActiveDataFlow SHALL ensure DataFlow models provide the same public methods regardless of backend
2. THE ActiveDataFlow SHALL ensure DataFlowRun models provide the same public methods regardless of backend
3. THE ActiveDataFlow SHALL ensure associations (has_many, belongs_to) work consistently across backends
4. THE ActiveDataFlow SHALL ensure scopes (active, pending, due_to_run) work consistently across backends
5. THE ActiveDataFlow SHALL ensure validations work consistently across backends

### Requirement 5: Dynamic Model Loading

**User Story:** As a Rails developer, I want ActiveDataFlow to automatically load the correct model implementations based on my configuration, so that I don't need to manually require different files.

#### Acceptance Criteria

1. WHEN the Rails engine initializes, THE ActiveDataFlow SHALL read the storage_backend configuration
2. THE ActiveDataFlow SHALL load models from `app/models/active_data_flow/active_record/` when using `:active_record` backend
3. THE ActiveDataFlow SHALL load models from `app/models/active_data_flow/redcord/` when using `:redcord_redis` or `:redcord_redis_emulator` backend
4. THE ActiveDataFlow SHALL set up the correct autoload paths based on the configured backend
5. THE ActiveDataFlow SHALL ensure models are available before the application starts processing requests

### Requirement 6: Configuration File Generation

**User Story:** As a Rails developer, I want a generator to create the configuration file, so that I can easily set up ActiveDataFlow with my preferred storage backend.

#### Acceptance Criteria

1. THE ActiveDataFlow SHALL provide a generator command `rails generate active_data_flow:install`
2. WHEN the generator runs, THE ActiveDataFlow SHALL create `config/initializers/active_data_flow.rb`
3. THE ActiveDataFlow SHALL include commented examples for `:active_record`, `:redcord_redis`, and `:redcord_redis_emulator` backends
4. THE ActiveDataFlow SHALL include documentation about required gems for each backend
5. THE ActiveDataFlow SHALL not overwrite an existing configuration file without confirmation

### Requirement 7: Redis Connection Configuration

**User Story:** As a Rails developer using Redcord, I want to configure the Redis connection, so that ActiveDataFlow can connect to my Redis instance or redis-emulator.

#### Acceptance Criteria

1. WHEN storage_backend is `:redcord_redis`, THE ActiveDataFlow SHALL accept a `redis_config` option
2. THE ActiveDataFlow SHALL support configuring Redis URL, host, port, and database
3. WHEN storage_backend is `:redcord_redis_emulator`, THE ActiveDataFlow SHALL use Rails.cache as the backing store
4. THE ActiveDataFlow SHALL validate Redis connectivity during initialization for `:redcord_redis` backend
5. THE ActiveDataFlow SHALL provide clear error messages if Redis connection fails

### Requirement 8: Migration and Schema Management

**User Story:** As a Rails developer, I want appropriate schema management for each backend, so that I can set up the storage layer correctly.

#### Acceptance Criteria

1. WHEN using `:active_record` backend, THE ActiveDataFlow SHALL provide Rails migrations
2. WHEN using `:redcord_redis` or `:redcord_redis_emulator` backend, THE ActiveDataFlow SHALL define schema in the model using Redcord DSL
3. THE ActiveDataFlow SHALL provide documentation on schema setup for each backend
4. THE ActiveDataFlow SHALL ensure schema changes are backward compatible within a backend
5. THE ActiveDataFlow SHALL not require SQL migrations when using Redcord backends

### Requirement 9: Error Handling and Validation

**User Story:** As a Rails developer, I want clear error messages when configuration is invalid, so that I can quickly identify and fix configuration issues.

#### Acceptance Criteria

1. WHEN an unsupported storage backend is configured, THE ActiveDataFlow SHALL raise a ConfigurationError
2. WHEN required gems are missing for a backend, THE ActiveDataFlow SHALL raise a clear error with installation instructions
3. WHEN Redis connection fails for Redcord backend, THE ActiveDataFlow SHALL raise a ConnectionError
4. THE ActiveDataFlow SHALL validate configuration during Rails initialization
5. THE ActiveDataFlow SHALL log configuration details at startup for debugging

### Requirement 10: Documentation and Examples

**User Story:** As a Rails developer, I want documentation and examples for each storage backend, so that I can understand how to configure and use them.

#### Acceptance Criteria

1. THE ActiveDataFlow SHALL provide README documentation for storage backend configuration
2. THE ActiveDataFlow SHALL include example configuration for `:active_record` backend
3. THE ActiveDataFlow SHALL include example configuration for `:redcord_redis` backend
4. THE ActiveDataFlow SHALL include example configuration for `:redcord_redis_emulator` backend
5. THE ActiveDataFlow SHALL document the trade-offs between storage backends
6. THE ActiveDataFlow SHALL provide a working example application (rails8-redcord) demonstrating `:redcord_redis_emulator` usage
