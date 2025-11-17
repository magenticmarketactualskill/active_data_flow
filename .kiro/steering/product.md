# Product Overview

ActiveDataFlow is a modular stream processing framework for Ruby inspired by Apache Flink. It provides a plugin-based architecture where a core gem defines abstract interfaces (Source, Sink, DataFlow) and separate gems provide concrete implementations for different runtimes and connectors.

## Key Components

- **Core**: Abstract interfaces and base classes for sources, sinks, and data flows
- **Runtimes**: Execution environments (currently: Rails Heartbeat; planned: ActiveJob, AWS Lambda, Flink)
- **Connectors**: Data source/sink implementations (currently: ActiveRecord; planned: Kafka, Cache, File, Iceberg)
- **Framework Extensions**: Additional capabilities like split-based source support

## Message Types

All data flows work with `ActiveDataflow::Message` instances:
- `ActiveDataflow::Message::Typed` - Typed messages with schema validation
- `ActiveDataflow::Message::Untyped` - Untyped messages for flexible data handling

## Architecture Philosophy

The framework follows a strict separation between abstract interfaces (core) and concrete implementations (runtime/connector gems). This allows applications to mix and match runtimes and connectors based on their needs without tight coupling.
