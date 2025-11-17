# Dependency Requirements for Parents

## Introduction

This document specifies how modules in ActiveDataflow relate and what dependencies exist.

See main requirements: `.kiro/specs/requirements.md` (Requirement 13: Modular Gem Architecture)

## Module Structure

- **Core gem** (`active_data_flow`): Defines abstract interfaces only
- **Runtime gems** (e.g., `active_data_flow-runtime-heartbeat`): Provide execution environments
- **Connector gems** (e.g., `active_data_flow-connector-source-active_record`): Provide data sources/sinks

See: `.kiro/steering/structure.md` for detailed project structure
