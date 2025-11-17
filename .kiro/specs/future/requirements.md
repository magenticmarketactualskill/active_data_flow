# Future Requirements

## Introduction

This document lists planned future implementations. DO NOT IMPLEMENT YET.

See main requirements: `.kiro/specs/requirements.md` for current requirements
See: `.kiro/steering/product.md` for product roadmap

## Planned Connector Implementations

- `active_data_flow-connector-source-kafka` - Kafka stream reading
- `active_data_flow-connector-sink-kafka` - Kafka stream writing
- `active_data_flow-connector-source-file` - File system reading (CSV, JSON)
- `active_data_flow-connector-sink-file` - File system writing
- `active_data_flow-connector-source-iceberg` - Apache Iceberg table reading
- `active_data_flow-connector-sink-iceberg` - Apache Iceberg table writing
- `active_data_flow-connector-sink-cache` - Rails cache writing

## Planned Runtime Implementations

- `active_data_flow-runtime-active_job` - ActiveJob background execution
- `active_data_flow-runtime-aws_lambda` - AWS Lambda serverless execution
- `active_data_flow-runtime-flink` - Apache Flink distributed execution