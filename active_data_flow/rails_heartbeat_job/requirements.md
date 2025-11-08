# ActiveDataFlow Rails Heartbeat Job - Requirements Document

## Introduction

This document specifies the requirements for the `active_data_flow-rails_heartbeat_job` gem, which provides asynchronous DataFlow execution using ActiveJob background jobs.

## Glossary

- **DataFlowRunJob**: An ActiveJob that executes a DataFlow asynchronously
- **Job Queue**: The background job queue where DataFlowRunJobs are enqueued

## Requirements

### Requirement 1: DataFlowRunJob

**User Story:** As a developer, I want asynchronous execution, so that long-running DataFlows don't block the heartbeat endpoint.

#### Acceptance Criteria

1. THE RailsHeartbeatJob SHALL provide a DataFlowRunJob ActiveJob class
2. THE DataFlowRunJob SHALL accept a data_flow_id parameter
3. THE DataFlowRunJob SHALL find the DataFlow record by ID
4. THE DataFlowRunJob SHALL instantiate the DataFlow class from its name
5. THE DataFlowRunJob SHALL execute the DataFlow's run method

### Requirement 2: Execution Logging

**User Story:** As a system operator, I want detailed execution logs, so that I can debug failures and monitor performance.

#### Acceptance Criteria

1. WHEN a job starts, THE RailsHeartbeatJob SHALL create a DataFlowRun with pending status
2. THE RailsHeartbeatJob SHALL update status to in_progress before execution
3. WHEN execution succeeds, THE RailsHeartbeatJob SHALL update status to success
4. IF execution fails, THEN THE RailsHeartbeatJob SHALL record error message and backtrace
5. THE RailsHeartbeatJob SHALL record started_at and ended_at timestamps

### Requirement 3: Error Handling

**User Story:** As a developer, I want proper error handling, so that failures are logged and can be retried.

#### Acceptance Criteria

1. THE RailsHeartbeatJob SHALL catch all exceptions during execution
2. THE RailsHeartbeatJob SHALL update DataFlow last_run_status to failed on error
3. THE RailsHeartbeatJob SHALL update DataFlowRun with error details
4. THE RailsHeartbeatJob SHALL re-raise exceptions for ActiveJob retry handling
5. THE RailsHeartbeatJob SHALL support configurable retry attempts

### Requirement 4: Job Enqueueing

**User Story:** As a developer, I want automatic job enqueueing, so that DataFlows are executed asynchronously.

#### Acceptance Criteria

1. THE RailsHeartbeatJob SHALL override the trigger_run! method from rails_heartbeat_app
2. WHEN trigger_run! is called, THE RailsHeartbeatJob SHALL enqueue a DataFlowRunJob
3. THE RailsHeartbeatJob SHALL update last_run_at immediately when enqueueing
4. THE RailsHeartbeatJob SHALL set last_run_status to in_progress
5. THE RailsHeartbeatJob SHALL use perform_later for asynchronous execution

### Requirement 5: Queue Configuration

**User Story:** As a developer, I want configurable job queues, so that I can prioritize different DataFlows.

#### Acceptance Criteria

1. THE RailsHeartbeatJob SHALL support per-DataFlow queue configuration
2. THE RailsHeartbeatJob SHALL default to the 'default' queue
3. THE RailsHeartbeatJob SHALL allow queue name in DataFlow configuration
4. THE RailsHeartbeatJob SHALL pass queue name to perform_later
5. THE RailsHeartbeatJob SHALL validate queue names are valid

### Requirement 6: Job Monitoring

**User Story:** As a system operator, I want job monitoring, so that I can track queued and running DataFlows.

#### Acceptance Criteria

1. THE RailsHeartbeatJob SHALL integrate with ActiveJob instrumentation
2. THE RailsHeartbeatJob SHALL emit events for job enqueue, start, and finish
3. THE RailsHeartbeatJob SHALL include DataFlow name in job metadata
4. THE RailsHeartbeatJob SHALL support custom monitoring callbacks
5. THE RailsHeartbeatJob SHALL track job duration in DataFlowRun records
