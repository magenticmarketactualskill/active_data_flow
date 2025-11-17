# Runtime Requirements for Parents

## Introduction

This document specifies the runtime abstractions that parent applications can use.

See main requirements: `.kiro/specs/requirements.md` (Requirements 7-9, 14)

## Core Runtime Classes

### Abstract Class

- `ActiveDataflow::Runtime` - Base runtime class for execution environments

### Default Implementation

- `ActiveDataflow::Runtime::Heartbeat` - Heartbeat-triggered execution with Rails integration

The Heartbeat runtime provides:
- Periodic execution via REST endpoint
- DataFlow scheduling and status management
- Asynchronous job execution via ActiveJob

See: `.kiro/specs/requirements.md` Requirements 7-9 for detailed acceptance criteria
