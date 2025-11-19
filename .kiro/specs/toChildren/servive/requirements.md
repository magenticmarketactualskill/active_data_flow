# Flow Execution Service Requirements

## Introduction

The Flow Execution Service orchestrates data flow execution, managing run records, flow instantiation, status tracking, and error handling.

See: `../../glossary.md` for terminology

## Requirements

### Requirement 1: Service Interface

**User Story:** As a Rails developer, I want a simple service interface, so that I can easily execute flows from any application component

#### Acceptance Criteria

1. THE Service SHALL provide `FlowExecutor.execute(data_flow)` as the primary interface
2. THE Service SHALL encapsulate all execution logic in private methods
3. THE Service SHALL manage the complete lifecycle from a single entry point
4. THE Service SHALL return the execution result

### Requirement 2: Run Record Management

**User Story:** As a system administrator, I want run records for each execution, so that I can track execution history

#### Acceptance Criteria

1. THE Service SHALL create a DataFlowRun with status "pending" and `started_at` timestamp
2. THE Service SHALL update status to "in_progress" before flow execution
3. THE Service SHALL associate the run record with the DataFlow
4. THE Service SHALL update status to "success" or "failed" with `ended_at` timestamp upon completion

### Requirement 3: Flow Instantiation

**User Story:** As a system component, I want flow instantiation with correct configuration, so that the flow logic executes properly

#### Acceptance Criteria

1. THE Service SHALL retrieve the flow class using DataFlow's `flow_class` method
2. THE Service SHALL instantiate the flow class with DataFlow configuration
3. THE Service SHALL call the `run` method on the flow instance

### Requirement 4: Status Tracking

**User Story:** As a system administrator, I want execution status tracking, so that I can monitor flow outcomes

#### Acceptance Criteria

1. THE Service SHALL update DataFlow's `last_run_at` and `last_run_status` after execution
2. THE Service SHALL set `last_run_status` to "success" when execution completes without errors
3. THE Service SHALL set `last_run_status` to "failed" when exceptions occur
4. THE Service SHALL persist all status updates to the database

### Requirement 5: Error Handling

**User Story:** As a system administrator, I want failure tracking with error details, so that I can diagnose issues

#### Acceptance Criteria

1. THE Service SHALL capture exceptions during execution
2. THE Service SHALL store exception message in run record's `error_message`
3. THE Service SHALL store exception backtrace in run record's `error_backtrace`
4. THE Service SHALL update both DataFlow and run record to "failed" status
5. THE Service SHALL re-raise the exception after recording the failure
