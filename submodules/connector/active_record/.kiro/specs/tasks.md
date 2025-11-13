# Implementation Plan

- [x] 1. Set up project structure and dependencies
  - Create lib directory structure for source and sink components
  - Configure Gemfile with activerecord and activesupport dependencies
  - Create main entry point file active_data_flow-active_record.rb
  - _Requirements: 1.1, 8.1_

- [x] 2. Implement ActiveRecord Sink core functionality
  - [x] 2.1 Create Sink::ActiveRecord class with configuration
    - Write class inheriting from ActiveDataFlow::Sink
    - Implement initialize method accepting configuration hash
    - Add model_name validation in configuration
    - _Requirements: 1.1, 1.2, 1.4_

  - [x] 2.2 Implement model resolution
    - Write resolve_model private method using constantize
    - Handle NameError for invalid model names
    - Support namespaced model names
    - _Requirements: 1.4_

  - [x] 2.3 Implement single record write
    - Write write_single private method using create!
    - Handle validation errors with logging
    - Support skip_validations configuration
    - _Requirements: 1.3, 2.1, 2.2, 2.4_

  - [x] 2.4 Write unit tests for core sink functionality
    - Test configuration validation
    - Test model resolution with valid and invalid names
    - Test single record write success and failure cases
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_

- [x] 3. Implement batch writing for Sink
  - [x] 3.1 Add batch buffer and flush logic
    - Create @buffer instance variable for record storage
    - Implement write method with buffering logic
    - Write flush method to process buffered records
    - Implement close method to flush remaining records
    - _Requirements: 3.1, 3.2, 3.4, 3.5_

  - [x] 3.2 Implement batch insert with insert_all
    - Write write_batch private method using insert_all
    - Handle batch_size configuration
    - Trigger automatic flush when buffer reaches batch_size
    - _Requirements: 3.3, 3.4_

  - [x] 3.3 Write unit tests for batch writing
    - Test buffering behavior
    - Test automatic flush at batch_size
    - Test manual flush method
    - Test close method flushes remaining records
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [x] 4. Implement upsert support for Sink
  - [x] 4.1 Add upsert configuration and logic
    - Support upsert boolean configuration
    - Support unique_by configuration for conflict detection
    - Support update_only configuration for selective updates
    - Modify write_batch to use upsert_all when enabled
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

  - [x] 4.2 Write unit tests for upsert functionality
    - Test upsert_all with unique_by
    - Test update_only behavior
    - Test conflict handling
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [x] 5. Implement transaction management for Sink
  - [x] 5.1 Add transaction wrapping
    - Write execute_in_transaction private method
    - Support transaction boolean configuration
    - Support transaction_batch_size configuration
    - Wrap write operations in transactions when enabled
    - Handle rollback on errors
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

  - [x] 5.2 Write unit tests for transaction management
    - Test transaction wrapping
    - Test rollback on errors
    - Test commit on success
    - Test transaction_batch_size
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

- [x] 6. Implement connection and performance optimizations for Sink
  - [x] 6.1 Add connection management
    - Use Rails connection pool
    - Handle connection timeouts with retry logic
    - Support multiple database configurations
    - Validate connectivity on initialization
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

  - [x] 6.2 Add performance optimization options
    - Support skip_callbacks configuration
    - Support skip_validations configuration
    - _Requirements: 7.1, 7.2_

  - [x] 6.3 Write unit tests for connection and performance features
    - Test connection pool usage
    - Test connection timeout handling
    - Test skip_callbacks option
    - Test skip_validations option
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 7.1, 7.2_

- [x] 7. Implement ActiveRecord Source core functionality
  - [x] 7.1 Create Source::ActiveRecord class with configuration
    - Write class inheriting from ActiveDataFlow::Source
    - Implement initialize method accepting configuration hash
    - Add model_name validation in configuration
    - _Requirements: 8.1, 8.2, 8.4_

  - [x] 7.2 Implement model resolution for Source
    - Write resolve_model private method using constantize
    - Handle NameError for invalid model names
    - Support namespaced model names
    - _Requirements: 8.4_

  - [x] 7.3 Implement query building
    - Write build_query private method
    - Support where configuration for filtering
    - Support order configuration for sorting
    - Support limit configuration for result size
    - Support select configuration for column selection
    - Support includes configuration for eager loading
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_

  - [x] 7.4 Write unit tests for core source functionality
    - Test configuration validation
    - Test model resolution
    - Test query building with various options
    - _Requirements: 8.1, 8.2, 8.4, 9.1, 9.2, 9.3, 9.4, 9.5_

- [x] 8. Implement record iteration for Source
  - [x] 8.1 Implement each method with batch support
    - Write each public method yielding records
    - Write iterate_records private method
    - Use find_each for batch iteration when batch_size configured
    - Use regular each for non-batched iteration
    - Support readonly mode configuration
    - _Requirements: 8.3, 10.1, 10.2, 10.3, 10.4, 10.5, 11.1, 11.2, 11.5_

  - [x] 8.2 Implement close method for Source
    - Write close method to release resources
    - Ensure database connections are released
    - _Requirements: 11.5_

  - [x] 8.3 Write unit tests for record iteration
    - Test each method yields all records
    - Test batch iteration with find_each
    - Test memory efficiency with large datasets
    - Test readonly mode
    - Test close method
    - _Requirements: 8.3, 10.1, 10.2, 10.3, 10.4, 10.5, 11.1, 11.2, 11.5_

- [x] 9. Implement connection and performance optimizations for Source
  - [x] 9.1 Add connection management for Source
    - Use Rails connection pool
    - Handle connection timeouts with retry logic
    - Support multiple database configurations
    - Validate connectivity on initialization
    - _Requirements: 12.1, 12.2, 12.3, 12.4, 12.5_

  - [x] 9.2 Add performance optimization options for Source
    - Support readonly mode (default true)
    - Optimize select usage for column filtering
    - Optimize includes for eager loading
    - _Requirements: 13.1, 13.3_

  - [x] 9.3 Write unit tests for Source connection and performance features
    - Test connection pool usage
    - Test connection timeout handling
    - Test readonly mode
    - Test select optimization
    - Test includes optimization
    - _Requirements: 12.1, 12.2, 12.3, 12.4, 12.5, 13.1, 13.3_

- [x] 10. Implement error handling for both Source and Sink
  - [x] 10.1 Add comprehensive error handling
    - Implement handle_error private method for Sink
    - Handle ActiveRecord::RecordNotUnique for Sink
    - Handle ActiveRecord::RecordInvalid for Sink
    - Handle ActiveRecord::StatementInvalid for Source
    - Handle ActiveRecord::ConnectionTimeoutError for both
    - Add logging for all error types
    - _Requirements: 1.5, 2.3, 2.4, 8.5_

  - [x] 10.2 Write unit tests for error handling
    - Test validation error handling in Sink
    - Test unique constraint violation handling in Sink
    - Test query error handling in Source
    - Test connection error handling for both
    - _Requirements: 1.5, 2.3, 2.4, 8.5_

- [x] 11. Create main entry point and wire components
  - [x] 11.1 Create active_data_flow-active_record.rb entry point
    - Require activerecord and activesupport
    - Require active_data_flow core gem
    - Require sink/active_record
    - Require source/active_record
    - _Requirements: 1.1, 8.1_

  - [x] 11.2 Create integration tests
    - Test Sink and Source working together
    - Test reading from one table and writing to another
    - Test end-to-end data flow
    - _Requirements: 1.1, 8.1_
