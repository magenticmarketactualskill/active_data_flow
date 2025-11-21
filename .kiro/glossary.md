# Glossary

This glossary defines key terms used throughout the ActiveDataFlow project.

## Core Terms

- **ActiveDataFlow**: The Ruby module namespace for the active_data_flow gem suite
- **Source**: A component that reads data from external systems (e.g., databases, files, streams)
- **Sink**: A component that writes data to external systems (e.g., databases, caches, files)
- **Runtime**: An execution environment for DataFlows that determines how and when they run
- **DataFlow**: An orchestration that reads from sources, transforms data, and writes to sinks
- **Connector**: A source or sink implementation for a specific external system
- **Message**: A data container passed between sources, transforms, and sinks

## Runtime Terms

- **Heartbeat**: A periodic REST endpoint trigger for autonomous DataFlow execution
- **Runner**: The component within a runtime that executes DataFlow logic

## Architecture Terms

- **Subgem**: A gem component managed within the same repository as the core gem
- **Submodule**: A gem component managed in a separate repository but included via git submodules
- **Rails Engine**: A Rails component that provides controllers, models, and views for integration

## Message Types

- **Typed Message**: A message with schema validation (`ActiveDataFlow::Message::Typed`)
- **Untyped Message**: A message for flexible data handling (`ActiveDataFlow::Message::Untyped`)

## Implementation Terms

- **ActiveRecord Connector**: Source/sink implementations for database tables using Rails ActiveRecord
- **Heartbeat Runtime**: A runtime implementation that executes DataFlows via periodic REST triggers

## Service Terms

- **FlowExecutor Service**: Service class managing data flow execution lifecycle
- **Run Record**: DataFlowRun instance tracking a single execution
- **Flow Instance**: Instantiated flow class performing data processing
- **Execution Lifecycle**: State sequence: pending → in_progress → success/failed

## Model Terms

- **DataFlow Model**: ActiveRecord model representing a configured data flow with scheduling and execution settings
- **DataFlowRun Model**: ActiveRecord model representing a single execution instance of a data flow
- **Run Interval**: Minimum time in seconds between executions of a data flow
- **Flow Class**: Ruby class implementing the actual data flow logic
- **Run Status**: Current state of a flow execution (pending, in_progress, success, failed)
