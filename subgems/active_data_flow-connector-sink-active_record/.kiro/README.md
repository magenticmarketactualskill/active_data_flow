# ActiveRecord Sink Connector .kiro Directory

This directory contains specifications and steering guidelines for the ActiveRecord sink connector subgem.

## Structure

```
.kiro/
├── specs/
│   ├── requirements.md        # Sink-specific requirements
│   ├── design.md              # Sink implementation design
│   ├── tasks.md               # Implementation tasks
│   ├── parent_requirements.md # Symlink to parent requirements
│   └── parent_design.md       # Symlink to parent design
├── steering/
│   ├── glossary.md            # Symlink to parent glossary
│   ├── product.md             # Symlink to parent product overview
│   ├── structure.md           # Symlink to parent structure
│   ├── tech.md                # Symlink to parent tech stack
│   ├── design_gem.md          # Symlink to parent gem design guidelines
│   ├── dry.md                 # Symlink to parent DRY principles
│   └── test_driven_design.md  # Symlink to parent testing guidelines
├── settings/                  # Subgem-specific settings
└── README.md                  # This file
```

## File Organization

### Symbolic Links

Files linked to parent (active_data_flow) documentation:
- **steering/** - All steering files are symlinked to maintain consistency
- **specs/parent_*.md** - Reference links to parent specs for context

### Subgem-Specific Files

Files specific to the ActiveRecord sink connector:
- **specs/requirements.md** - Sink-specific requirements (5 requirements)
- **specs/design.md** - Implementation details
- **specs/tasks.md** - Implementation and testing tasks

## Usage

When working on the ActiveRecord sink connector:

1. **Read parent context**: Check symlinked files for overall project guidelines
2. **Focus on subgem specs**: Work with requirements.md, design.md, tasks.md
3. **Follow parent guidelines**: Steering files provide consistent development practices
4. **Reference parent requirements**: See Requirement 3 in parent requirements

## Key Requirements

From parent requirements (Requirement 3):
- Provide `Connector::Sink::ActiveRecord` class for writing to database tables
- Accept model name configuration
- Handle database errors gracefully

## Key Features

- **Single Record Writes**: `write` method for individual records
- **Batch Writes**: `write_batch` method using `insert_all` for efficiency
- **Flexible Input**: Accepts Hash, Untyped, and Typed messages
- **Error Handling**: Clear error messages with proper exception types
- **Model Resolution**: Supports Class, String, and Symbol model configuration

## Related Documentation

- Parent Requirements: `../../../../.kiro/specs/requirements.md` - Requirement 3
- Parent Design: `../../../../.kiro/specs/design.md` - Section 3
- Parent Tasks: `../../../../.kiro/specs/tasks.md` - Task 7
