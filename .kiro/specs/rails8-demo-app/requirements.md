# Rails 8 Demo App Requirements

## Introduction

This document specifies requirements for a Rails 8 demonstration application that showcases ActiveDataflow functionality. The app will be created as a git submodule to demonstrate real-world usage of the framework.

See: `../requirements.md` for parent ActiveDataflow requirements

## Glossary

See: `../../glossary.md` for shared terminology

- **Demo App**: A complete Rails application demonstrating ActiveDataflow usage
- **Submodule**: A git submodule containing the demo application
- **Example DataFlow**: A working DataFlow implementation in the demo app

## Requirements

### Requirement 1: Rails 8 Application Setup

**User Story:** As a developer, I want a complete Rails 8 application, so that I can see ActiveDataflow in a real Rails environment.

#### Acceptance Criteria

1. THE Demo App SHALL be a Rails 8 application
2. THE Demo App SHALL be created as a git submodule in `submodules/examples/rails8-demo`
3. THE Demo App SHALL include ActiveDataflow gems as dependencies
4. THE Demo App SHALL use SQLite for simplicity
5. THE Demo App SHALL include seed data for demonstration

### Requirement 2: ActiveDataflow Integration

**User Story:** As a developer, I want to see ActiveDataflow integrated into Rails, so that I understand how to use it in my own applications.

#### Acceptance Criteria

1. THE Demo App SHALL mount the ActiveDataflow Rails engine
2. THE Demo App SHALL include at least one custom DataFlow class
3. THE Demo App SHALL configure the heartbeat runtime
4. THE Demo App SHALL use ActiveRecord source and sink connectors
5. THE Demo App SHALL demonstrate data transformation

### Requirement 3: Example DataFlow Implementation

**User Story:** As a developer, I want a working DataFlow example, so that I can understand the framework's capabilities.

#### Acceptance Criteria

1. THE Demo App SHALL implement a DataFlow that reads from one table
2. THE Demo App SHALL implement transformation logic in the DataFlow
3. THE Demo App SHALL write transformed data to another table
4. THE Demo App SHALL use Message types (Typed or Untyped)
5. THE Demo App SHALL handle errors gracefully

### Requirement 4: User Interface

**User Story:** As a developer, I want a web interface, so that I can interact with DataFlows visually.

#### Acceptance Criteria

1. THE Demo App SHALL provide a web interface for viewing DataFlows
2. THE Demo App SHALL display DataFlow execution history
3. THE Demo App SHALL allow manual triggering of DataFlows
4. THE Demo App SHALL show execution status and errors
5. THE Demo App SHALL use the ActiveDataflow engine views

### Requirement 5: Documentation and Setup

**User Story:** As a developer, I want clear setup instructions, so that I can run the demo app quickly.

#### Acceptance Criteria

1. THE Demo App SHALL include a README with setup instructions
2. THE Demo App SHALL include database setup commands
3. THE Demo App SHALL include seed data loading instructions
4. THE Demo App SHALL document how to trigger DataFlows
5. THE Demo App SHALL include troubleshooting guidance

### Requirement 6: Example Use Case

**User Story:** As a developer, I want a realistic use case, so that I can understand practical applications.

#### Acceptance Criteria

1. THE Demo App SHALL implement a realistic business scenario
2. THE Demo App SHALL demonstrate data synchronization between tables
3. THE Demo App SHALL show data transformation patterns
4. THE Demo App SHALL include multiple DataFlow examples
5. THE Demo App SHALL demonstrate error handling and recovery
