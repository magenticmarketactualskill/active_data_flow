# Parent Requirements

## Introduction

This document specifies what parent applications (users of ActiveDataFlow) need to know.

## Key Information for Parents

See main requirements: `.kiro/specs/requirements.md`

### What ActiveDataFlow Provides

- A new top-level folder `./data_flow` where developers define SOURCE, SINK, and RUNTIME characteristics
- Controllers for managing and monitoring DataFlows
- A Rails engine (Heartbeat) triggered periodically by REST calls for autonomous execution
- Models to store DataFlow instance states

### Core Abstractions

See: `.kiro/specs/toParent/connector/requirements.md` for connector details
See: `.kiro/specs/toParent/runtime/requirements.md` for runtime details
See: `.kiro/specs/toParent/dependencies/requirements.md` for dependency information
