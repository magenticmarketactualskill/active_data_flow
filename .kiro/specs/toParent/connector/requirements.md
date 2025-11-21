# Connector Requirements for Parents

## Introduction

This document specifies the connector abstractions that parent applications can use.

See main requirements: `.kiro/specs/requirements.md` (Requirements 1-3, 13-15)

## Core Connector Classes

### Abstract Classes

- `ActiveDataFlow::Connector` - Base connector class
- `ActiveDataFlow::Connector::Source` - Base source class for reading data
- `ActiveDataFlow::Connector::Sink` - Base sink class for writing data

### Default Implementations

- `ActiveDataFlow::Connector::Source::ActiveRecord` - Read from database tables
- `ActiveDataFlow::Connector::Sink::ActiveRecord` - Write to database tables

See: `.kiro/specs/requirements.md` Requirements 2-3 for detailed acceptance criteria




