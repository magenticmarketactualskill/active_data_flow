# ActiveDataFlow Cache - Requirements Document

## Introduction

This document specifies the requirements for the `active_data_flow-cache` gem, which provides Sink implementation for writing data to Rails cache (Redis, Memcached, etc.).

## Glossary

- **Cache**: Rails cache store (Redis, Memcached, Memory, etc.)
- **TTL**: Time-to-live for cache entries
- **Key Attribute**: The record attribute used as the cache key

## Requirements

### Requirement 1: Cache Sink

**User Story:** As a developer, I want a cache sink, so that I can write processed data to Rails cache.

#### Acceptance Criteria

1. THE Cache gem SHALL provide an ActiveDataFlow::Sink::Cache class
2. THE Cache sink SHALL accept key_attribute configuration
3. THE Cache sink SHALL accept expires_in configuration for TTL
4. THE Cache sink SHALL implement the write method to cache records
5. THE Cache sink SHALL use Rails.cache for cache operations

### Requirement 2: Key Generation

**User Story:** As a developer, I want flexible key generation, so that I can control cache key structure.

#### Acceptance Criteria

1. THE Cache sink SHALL extract key from record using key_attribute
2. THE Cache sink SHALL support nested key attributes (e.g., "user.id")
3. THE Cache sink SHALL support key_prefix configuration
4. THE Cache sink SHALL support key_suffix configuration
5. THE Cache sink SHALL raise error if key attribute is missing from record

### Requirement 3: Value Serialization

**User Story:** As a developer, I want automatic serialization, so that complex objects are cached correctly.

#### Acceptance Criteria

1. THE Cache sink SHALL serialize records as JSON by default
2. THE Cache sink SHALL support custom serialization formats
3. THE Cache sink SHALL support Marshal serialization
4. THE Cache sink SHALL handle serialization errors gracefully
5. THE Cache sink SHALL support compression for large values

### Requirement 4: TTL Management

**User Story:** As a developer, I want TTL control, so that cached data expires appropriately.

#### Acceptance Criteria

1. WHEN expires_in is configured, THE Cache sink SHALL set TTL on write
2. THE Cache sink SHALL support expires_in in seconds
3. THE Cache sink SHALL support dynamic TTL based on record attributes
4. THE Cache sink SHALL support no expiration (nil expires_in)
5. THE Cache sink SHALL validate TTL values are positive

### Requirement 5: Batch Writing

**User Story:** As a developer, I want batch cache writes, so that I can improve write performance.

#### Acceptance Criteria

1. THE Cache sink SHALL support batch_size configuration
2. WHEN batch_size is set, THE Cache sink SHALL buffer records
3. THE Cache sink SHALL use write_multi for batch writes
4. THE Cache sink SHALL flush batches when buffer is full
5. THE Cache sink SHALL provide a flush method for manual flushing

### Requirement 6: Cache Store Compatibility

**User Story:** As a developer, I want compatibility with all Rails cache stores, so that I can use any backend.

#### Acceptance Criteria

1. THE Cache sink SHALL work with Redis cache store
2. THE Cache sink SHALL work with Memcached cache store
3. THE Cache sink SHALL work with Memory cache store
4. THE Cache sink SHALL work with File cache store
5. THE Cache sink SHALL handle store-specific limitations

### Requirement 7: Error Handling

**User Story:** As a developer, I want robust error handling, so that cache failures don't crash the pipeline.

#### Acceptance Criteria

1. THE Cache sink SHALL catch cache write errors
2. THE Cache sink SHALL log cache errors with context
3. THE Cache sink SHALL support fail_on_error configuration
4. WHEN fail_on_error is false, THE Cache sink SHALL continue on errors
5. THE Cache sink SHALL provide error callbacks for custom handling
