# Runtime Requirements for Children

## Introduction

This document specifies requirements for implementing ActiveDataflow runtimes.

See main requirements: `.kiro/specs/requirements.md` (Requirements 7-9, 14)

## Implementation Requirements

### Base Class

All runtime implementations MUST extend `ActiveDataflow::Runtime`

### Default Implementation

The default runtime is `ActiveDataflow::Runtime::Heartbeat` which provides:
- Heartbeat-triggered execution (Requirement 7)
- DataFlow scheduling and status management (Requirement 8)
- Asynchronous job execution (Requirement 9)

See: `.kiro/specs/requirements.md` Requirements 7-9 for detailed acceptance criteria

